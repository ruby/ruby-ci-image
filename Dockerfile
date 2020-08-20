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
COPY --from=assets /etc/ssl /etc/ssl
COPY --from=assets /etc/apt /etc/apt
COPY --from=assets /etc/dpkg /etc/dpkg

RUN set -ex                                     \
 && apt-get update                              \
 && apt-get install                             \
        clang-3.9 llvm-3.9 llvm-3.9-dev         \
        clang-4.0 llvm-4.0 llvm-4.0-dev lld-4.0 \
        clang-5.0 llvm-5.0 llvm-5.0-dev lld-5.0 \
        clang-6.0 llvm-6.0 llvm-6.0-dev lld-6.0 \
        clang-7   llvm-7   llvm-7-dev   lld-7   \
        clang-8   llvm-8   llvm-8-dev   lld-8   \
        clang-9   llvm-9   llvm-9-dev   lld-9   \
        clang-10  llvm-10  llvm-10-dev  lld-10  \
        clang-11  llvm-11  llvm-11-dev  lld-11  \
        clang-12  llvm-12  llvm-12-dev  lld-12  \
        gcc-4.8   g++-4.8                       \
        gcc-5     g++-5                         \
        gcc-6     g++-6                         \
        gcc-7     g++-7                         \
        gcc-8     g++-8                         \
        gcc-9     g++-9                         \
        gcc-10    g++-10                        \
        doxygen                                 \
        libjemalloc-dev                         \
        openssl                                 \
        ruby                                    \
        tzdata                                  \
        valgrind                                \
 && apt-get build-dep ruby2.5
