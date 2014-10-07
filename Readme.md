# failover-lb

This repository provides a simple build script to automate creating RPMs for
[HAProxy](http://haproxy.org/) and [Keepalived](http://keepalived.org/).

This repository includes files from the following projects:

* [https://github.com/bluerail/haproxy-centos/](https://github.com/bluerail/haproxy-centos/)
* [https://github.com/santisaez/powerstack/](https://github.com/santisaez/powerstack/)

## Building

1. Clone this repository
2. Run the `build.sh` script

That's really all there is to it. Running `build.sh` without a parameter will build both
HAProxy and Keepalived. You can choose to build a single package by specifying the name:

    ./build.sh haproxy

or

    ./build.sh keepalived

During the build process a 'rpmbuild' directory will be created in the root directory
of the repository. Once the builds are complete, you can find the RPMs in the
'rpmbuild/RPMS/' directory.

## License

[http://jsumners.mit-license.org](http://jsumners.mit-license.org)

THE MIT LICENSE (MIT)
Copyright © 2014 James Sumners <james.sumners@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
