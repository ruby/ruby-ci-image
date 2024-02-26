ARG os=ubuntu
ARG version=
ARG variant=
ARG build_ruby=
ARG system_ruby=
ARG packages=

FROM ${os}:${version}${variant} as assets
ARG os
ARG version
ARG variant

RUN apt-get update
RUN apt-get install -y wget gnupg2 ca-certificates sudo
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key \
  | apt-key add -
RUN apt-key adv \
    --keyserver hkp://keyserver.ubuntu.com:80 \
    --recv-keys 60C317803A41BA51845E371A1E9377A2BA9EF27F
RUN grep '^deb ' /etc/apt/sources.list \
  | sed 's/^deb /deb-src /' \
  | tee /etc/apt/sources.list.d/deb-src.list
ADD assets/99apt.conf /etc/apt/apt.conf.d/
ADD assets/99dpkg.cfg /etc/dpkg/dpkg.cfg.d/
ADD assets/99${version}.list /etc/apt/sources.list.d/
ADD assets/sudoers /etc/sudoers.d/
RUN chmod 0440 /etc/sudoers.d/*

RUN mkdir /rust
RUN wget                         \
      --quiet                    \
      --https-only               \
      --secure-protocol=TLSv1_2  \
      --output-document=-        \
      https://sh.rustup.rs       \
  | env                          \
      RUSTUP_HOME=/rust/rustup   \
      CARGO_HOME=/rust/cargo     \
    /bin/sh                      \
      -s                         \
      --                         \
      --quiet                    \
      --default-toolchain=stable \
      --profile=minimal          \
      --component clippy         \
      --no-modify-path           \
      -y

FROM ${os}:${version}${variant} as compilers
ARG build_ruby
ARG system_ruby
ARG packages

LABEL maintainer=shyouhei@ruby-lang.org
ENV DEBIAN_FRONTEND=noninteractive
COPY --from=assets /etc/ssl /etc/ssl
COPY --from=assets /etc/apt /etc/apt
COPY --from=assets /etc/dpkg /etc/dpkg
COPY --from=assets /etc/sudoers.d /etc/sudoers.d
COPY --from=assets /rust /rust
ENV RUSTUP_HOME=/rust/rustup
ENV PATH=${PATH}:/rust/cargo/bin

COPY build_ruby.sh /tmp
RUN set -ex                                           \
 && apt-get update                                    \
 && apt-get install ${packages}                       \
    autoconf patch bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev \
    libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev \
    libjemalloc-dev tzdata valgrind wget ca-certificates sudo docker.io libcapstone-dev \
 && bash -c "if [[ -n '$system_ruby' ]]; then apt-get install 'ruby${system_ruby}'; fi" \
 && bash -c "if [[ -n '$build_ruby' ]]; then /tmp/build_ruby.sh '$build_ruby'; fi" \
 && rm /tmp/build_ruby.sh

RUN adduser --disabled-password --gecos '' ci && adduser ci sudo

USER ci
