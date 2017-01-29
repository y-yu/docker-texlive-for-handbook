FROM frolvlad/alpine-glibc

MAINTAINER yyu <m [at] yyu.pw>

ENV PATH /usr/local/texlive/2016/bin/x86_64-linux:$PATH

RUN apk --no-cache add perl wget xz tar fontconfig-dev make && \
    mkdir /tmp/install-tl-unx && \
    wget -qO- http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | \
    tar -xz -C /tmp/install-tl-unx --strip-components=1 && \
    printf "%s\n" \
      "selected_scheme scheme-basic" \
      "option_doc 0" \
      "option_src 0" \
      > /tmp/install-tl-unx/texlive.profile && \
    /tmp/install-tl-unx/install-tl \
      --profile=/tmp/install-tl-unx/texlive.profile && \
    tlmgr install \
      collection-basic collection-latex collection-latexrecommended \
      collection-fontsrecommended collection-langjapanese latexmk \
      enumitem piff menukeys xstring adjustbox collectbox relsize \
      catoptions cprotect bigfoot && \
    (tlmgr install xetex || exit 0) && \
    rm -fr /tmp/install-tl-unx && \
    apk --no-cache del xz tar fontconfig-dev

RUN apk --no-cache add bash

RUN mkdir /workdir

WORKDIR /workdir

VOLUME ["/workdir"]

CMD ["bash"]
