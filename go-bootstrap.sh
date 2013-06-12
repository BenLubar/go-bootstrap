#!/bin/sh -e

# Copyright (c) 2013 Ben Lubar. All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 	
#    * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
#    * Neither the name of Google Inc. nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 

export GOROOT="${GOROOT:-"/opt/ʕ ◔ϖ◔ʔ"}"
export GOPATH="${GOPATH:-"$HOME/go"}"

mkdir -p "$GOROOT"
cd "$GOROOT"
test -d "$GOROOT"/.hg || hg clone https://go.googlecode.com/hg/ "$GOROOT"
hg pull
hg update

cd src

echo '# Building C bootstrap tool.'
GOROOT_FINAL="${GOROOT_FINAL:-$GOROOT}"
DEFGOROOT='-DGOROOT_FINAL="'"$GOROOT_FINAL"'"'

mflag=
case "$GOHOSTARCH" in
386)   mflag=-m32  ;;
amd64) mflag=-m64  ;;
arm)   mflag=-marm ;;
esac

each_os_arch() {
	GOOS=linux    GOARCH=386    $1
	GOOS=linux    GOARCH=amd64  $1
	GOOS=linux    GOARCH=arm    $1
	GOOS=windows  GOARCH=386    $1
	GOOS=windows  GOARCH=amd64  $1
	GOOS=darwin   GOARCH=386    $1
	GOOS=darwin   GOARCH=amd64  $1
	GOOS=plan9    GOARCH=386    $1
	GOOS=plan9    GOARCH=amd64  $1
	GOOS=freebsd  GOARCH=386    $1
	GOOS=freebsd  GOARCH=amd64  $1
	GOOS=freebsd  GOARCH=arm    $1
	GOOS=netbsd   GOARCH=386    $1
	GOOS=netbsd   GOARCH=amd64  $1
	GOOS=netbsd   GOARCH=arm    $1
	GOOS=openbsd  GOARCH=386    $1
	GOOS=openbsd  GOARCH=amd64  $1
}

${CC:-gcc} $mflag -O2 -Wall -Werror -o cmd/dist/dist -Icmd/dist "$DEFGOROOT" cmd/dist/*.c

eval $(./cmd/dist/dist env -p)

echo "# Building compilers and Go bootstrap tool for host, $GOHOSTOS/$GOHOSTARCH."
./cmd/dist/dist bootstrap -a
# Delay move of dist tool to now, because bootstrap may clear tool directory.
mv cmd/dist/dist "$GOTOOLDIR"/dist
"$GOTOOLDIR"/go_bootstrap clean -i std
"$GOTOOLDIR"/dist install cmd/5l cmd/5a cmd/5c cmd/5g cmd/6l cmd/6a cmd/6c cmd/6g cmd/8l cmd/8a cmd/8c cmd/8g

echo "# Building packages and commands for host, $GOHOSTOS/$GOHOSTARCH."
GOOS=$GOHOSTOS GOARCH=$GOHOSTARCH "$GOTOOLDIR"/go_bootstrap install -ccflags "$GO_CCFLAGS" -gcflags "$GO_GCFLAGS" -ldflags "$GO_LDFLAGS" std

case "$GOHOSTOS-$GOHOSTARCH" in
linux-amd64|windows-amd64|darwin-amd64)
	echo "# Building race condition detection for host, $GOHOSTOS/$GOHOSTARCH."
	GOOS=$GOHOSTOS GOARCH=$GOHOSTARCH "$GOTOOLDIR"/go_bootstrap install -ccflags "$GO_CCFLAGS" -gcflags "$GO_GCFLAGS" -ldflags "$GO_LDFLAGS" -race std
	;;
esac

echo "# Bootstrapping cross compilers."
dist_install_runtime() {
	"$GOTOOLDIR"/dist install pkg/runtime
}
each_os_arch dist_install_runtime

echo "# Cross-compiling packages and commands."
cross_compile_packages() {
	"$GOTOOLDIR"/go_bootstrap install $GO_FLAGS -ccflags "$GO_CCFLAGS" -gcflags "$GO_GCFLAGS" -ldflags "$GO_LDFLAGS" std
}
each_os_arch cross_compile_packages

echo "# Updating GOPATH packages"
"$GOROOT"/bin/go get -d code.google.com/p/go.tools/cmd/...
"$GOROOT"/bin/go get -d -u all

echo "# Compiling GOPATH packages"
case "$GOHOSTOS-$GOHOSTARCH" in
linux-amd64|windows-amd64|darwin-amd64)
	GOOS=$GOHOSTOS GOARCH=$GOHOSTARCH "$GOROOT"/bin/go install -race ...
esac
install_dotdotdot() {
	"$GOROOT"/bin/go install ...
}
each_os_arch install_dotdotdot
GOOS=$GOHOSTOS GOARCH=$GOHOSTARCH install_dotdotdot

echo "# Done!"
