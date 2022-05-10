ARG os=ubuntu
ARG version=
ARG variant=
ARG baseruby=
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

FROM ${os}:${version}${variant} as compilers
ARG baseruby
ARG packages

LABEL maintainer=shyouhei@ruby-lang.org
ENV DEBIAN_FRONTEND=noninteractive
COPY --from=assets /etc/ssl /etc/ssl
COPY --from=assets /etc/apt /etc/apt
COPY --from=assets /etc/dpkg /etc/dpkg
COPY --from=assets /etc/sudoers.d /etc/sudoers.d

RUN set -ex                                           \
 && apt-get update                                    \
 && apt-get install ${packages}                       \
    libjemalloc-dev openssl libyaml-dev ruby tzdata valgrind sudo docker.io \
 && apt-get build-dep ruby${baseruby}

RUN adduser --disabled-password --gecos '' ci && adduser ci sudo

USER ci
