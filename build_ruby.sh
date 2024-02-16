#!/bin/bash
set -euxo pipefail

ruby_version="$1"

mkdir /tmp/build_ruby
trap 'rm -rf /tmp/build_ruby' EXIT
cd /tmp/build_ruby

wget "https://cache.ruby-lang.org/pub/ruby/${ruby_version:0:3}/ruby-${ruby_version}.tar.gz"
tar xvzf "ruby-${ruby_version}.tar.gz"
cd "ruby-${ruby_version}"

./configure --disable-install-doc
make -j
make install
