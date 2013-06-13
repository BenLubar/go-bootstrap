go-bootstrap
============
When this script is run:
* Go's source code is downloaded to or updated in your `$GOROOT`.
* Compilers for the following OS/ARCH combinations are built: linux/386 linux/amd64 linux/arm
  windows/386 windows/amd64 darwin/386 darwin/amd64 freebsd/386
  freebsd/amd64 freebsd/arm openbsd/386 openbsd/amd64
* The standard library is cross-compiled using each of the newly-built compilers.
* If the host OS is linux, windows, or darwin (Mac OS), and the architecture is amd64, a race-
  detection instrumented standard library and compiler suite are built for the native OS/ARCH.
* Tools such as `go vet` are downloaded if they are not already.
* All version-controlled projects in `$GOPATH` are updated.
* `$GOPATH` packages are built and installed for every OS/ARCH combination.

What you need to do:
* Add `$GOROOT/bin` and `$GOPATH/bin` to your `$PATH`. If you have multiple `$GOPATH`s, you
  should already know what to do.
* Run this script whenever you want to update Go.

Requirements
------------
* A bourne-compatible shell (/bin/sh)
* Read and write access to the directory `$GOROOT`, by default `/opt/ʕ ◔ϖ◔ʔ`
* Read and write access to the directories `$GOPATH`, by default `$HOME/go`
* Mercurial (hg)
* A C compiler `$CC`, by default `gcc`

Most Linux distributions have most or all of these pre-installed. Paths can be changed using
environment variables.

Example output
--------------
```
requesting all changes
adding changesets
adding manifests
adding file changes
added 17060 changesets with 60011 changes to 8135 files (+6 heads)
updating to branch default
3723 files updated, 0 files merged, 0 files removed, 0 files unresolved
pulling from https://go.googlecode.com/hg/
searching for changes
no changes found
0 files updated, 0 files merged, 0 files removed, 0 files unresolved
# Building C bootstrap tool.
# Building compilers and Go bootstrap tool for host, linux/amd64.
# Building packages and commands for host, linux/amd64.
# Building race condition detection for host, linux/amd64.
# Bootstrapping cross compilers.
# Cross-compiling packages and commands.
# Updating GOPATH packages
# Compiling GOPATH packages
# Done!
```

License
-------
Copyright (c) 2013 Ben Lubar. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:
	
* Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above
  copyright notice, this list of conditions and the following disclaimer
  in the documentation and/or other materials provided with the
  distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
