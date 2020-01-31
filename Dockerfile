FROM ubuntu:bionic as assets
MAINTAINER shyouhei@ruby-lang.org
RUN apt-get update
RUN apt-get install -y wget gnupg2 ca-certificates
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key \
  | apt-key add -
RUN apt-key adv \
    --keyserver hkp://keyserver.ubuntu.com:80 \
    --recv-keys 60C317803A41BA51845E371A1E9377A2BA9EF27F
RUN grep '^deb ' /etc/apt/sources.list \
  | sed 's/^deb /deb-src /' \
  | tee /etc/apt/sources.list.d/deb-src.list
RUN dpkg --add-architecture i386
ADD assets/99apt.conf /etc/apt/apt.conf.d/
ADD assets/99dpkg.cfg /etc/dpkg/dpkg.cfg.d/
ADD assets/98gcc.list  /etc/apt/sources.list.d/
ADD assets/99llvm.list /etc/apt/sources.list.d/

FROM ubuntu:bionic
MAINTAINER shyouhei@ruby-lang.org
ENV DEBIAN_FRONTEND=noninteractive
COPY --from=assets /etc/apt /etc/apt
COPY --from=assets /etc/dpkg /etc/dpkg

RUN set -ex \
 && dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install \
        gcc-4.8 g++-4.8  gcc-4.8-multilib g++-4.8-multilib \
        gcc-5   g++-5    gcc-5-multilib   g++-5-multilib \
        gcc-6   g++-6    gcc-6-multilib   g++-6-multilib \
        gcc-7   g++-7    gcc-7-multilib   g++-7-multilib \
        gcc-8   g++-8    gcc-8-multilib   g++-8-multilib \
        gcc-9   g++-9    gcc-9-multilib   g++-9-multilib \
        clang-3.9  libclang-3.9-dev \
        clang-4.0  libclang-4.0-dev \
        clang-5.0  libclang-5.0-dev \
        clang-6.0  libclang-6.0-dev \
        clang-7    libclang-7-dev   \
        clang-8    libclang-8-dev   \
        clang-9    libclang-9-dev   \
        clang-10   libclang-10-dev  \
        clang-11   libclang-11-dev  \
        libffi-dev libffi-dev:i386 libffi6:i386 \
        libgdbm-dev libgdbm-dev:i386 libgdbm5:i386 \
        libgmp-dev \
        libjemalloc-dev \
        libncurses5-dev libncurses5-dev:i386 libncurses5:i386 \
        libncursesw5-dev libncursesw5-dev:i386 \
        libreadline6-dev libreadline6-dev:i386 libreadline7:i386 \
        libssl-dev libssl-dev:i386 libssl1.1:i386 \
        libyaml-dev \
        linux-libc-dev:i386 \
        zlib1g-dev zlib1g-dev:i386 zlib1g:i386 \
        openssl \
        valgrind \
        doxygen \
        build-essential ruby \
        tzdata \
 && apt-get build-dep \
        ruby2.5 ruby2.5:i386
