#!/bin/bash

keepalivedVersion="1.2.19"
haproxyVersion="1.7.5"
luaVersion="5.3.1"

keepalivedUrl="http://keepalived.org/software/keepalived-${keepalivedVersion}.tar.gz"
haproxyUrl="http://www.haproxy.org/download/${haproxyVersion:0:3}/src/haproxy-${haproxyVersion}.tar.gz"
luaUrl="http://www.lua.org/ftp/lua-${luaVersion}.tar.gz"

which wget > /dev/null
if [ $? -ne 0 ]; then
  echo "Aborting. Cannot continue without wget."
  exit 1
fi

which rpmbuild > /dev/null
if [ $? -ne 0 ]; then
  echo "Aborting. Cannot continue without rpmbuild. Please install the rpmdevtools package."
  exit 1
fi

if [ "$1" != "" ]; then
  product=$(echo $1 | tr '[:upper:]' '[:lower:]')
else
  product="both"
fi

echo ${product} | grep -E '^(both|haproxy|keepalived)$' 2>&1 > /dev/null
if [ $? -ne 0 ]; then
  echo "Invalid product name. Valid options are 'keepalived', 'haproxy' or 'both'."
  echo "For example:"
  echo -e "\t./build.sh keepalived"
  exit 1
fi


# Let's get down to business
TOPDIR=$(pwd)

function buildit {
  if [ -f ${TOPDIR}/gpg-env ]; then
    source ${TOPDIR}/gpg-env
    echo "Building signed RPM..."
    if [ "${gpg_bin}" != "" ]; then
      rpmbuild --define "_topdir ${TOPDIR}/rpmbuild" --define "_signature ${signature}" \
        --define "_gpg_path ${gpg_path}" --define "_gpg_name ${gpg_name}" \
        --define "__gpg ${gpg_bin}" --sign -ba $1
    else
      rpmbuild --define "_topdir ${TOPDIR}/rpmbuild" --define "_signature ${signature}" \
        --define "_gpg_path ${gpg_path}" --define "_gpg_name ${gpg_name}" \
        --sign -ba $1
    fi
  else
    echo "Building unsigned RPM..."
    rpmbuild --define "_topdir ${TOPDIR}/rpmbuild" -ba $1
  fi

  if [ $? -ne 0 ]; then
    echo "Build failed. Exiting..."
    exit 1
  fi
}

if [ -e rpmbuild ]; then
  rm -rf rpmbuild/* 2>&1 > /dev/null
fi

echo "Creating RPM build path structure..."
mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS,tmp}

# haproxy
echo "${product}" | grep -E '^(both|haproxy)$' 2>&1 > /dev/null
if [ $? -eq 0 ]; then
  echo "Building HAProxy RPM ..."
  cp ${TOPDIR}/files/haproxy.{cfg,init,logrotate} ${TOPDIR}/rpmbuild/SOURCES/
  cp ${TOPDIR}/files/haproxy.spec ${TOPDIR}/rpmbuild/SPECS/

  sed -i 's/~haproxyVersion~/'${haproxyVersion}'/' ${TOPDIR}/rpmbuild/SPECS/haproxy.spec
  
  cd ${TOPDIR}/rpmbuild/SOURCES/
  wget ${haproxyUrl}
  
  cd ${TOPDIR}/rpmbuild/
  buildit "SPECS/haproxy.spec"
fi

# keepalived
echo "${product}" | grep -E '^(both|keepalived)$' 2>&1 > /dev/null
if [ $? -eq 0 ]; then
  echo "Building Keealived RPM ..."
  cp ${TOPDIR}/files/keepalived.spec ${TOPDIR}/rpmbuild/SPECS/

  sed -i 's/~keepalivedVersion~/'${keepalivedVersion}'/' ${TOPDIR}/rpmbuild/SPECS/keepalived.spec

  cd ${TOPDIR}/rpmbuild/SOURCES/
  wget ${keepalivedUrl}

  tar zxf keepalived-${keepalivedVersion}.tar.gz
  cd keepalived-${keepalivedVersion}/keepalived/etc/init.d/
  cp keepalived.rh.init ${TOPDIR}/rpmbuild/SOURCES/keepalived.init

  cd ${TOPDIR}/rpmbuild/
  buildit "SPECS/keepalived.spec"
fi
