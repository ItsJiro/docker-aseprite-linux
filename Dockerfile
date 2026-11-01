FROM python


#Required for tzdata
ENV TZ=Europe/Amsterdam


# Install dependencies
RUN apt-get update && \
    apt get install -y --no-install-recommends \
    git \
    unzip \
    curl \
    build-essential \
    clang \
    cmake \
    ninja-build \
    libx11-dev \
    libxcursor-dev \
    libxi-dev \
    libgl1-mesa-dev \
    libfontconfig1-dev && \
    COPY compile.sh /


VOLUME /dependencies
VOLUME /output

WORKDIR /output

RUN ["chmod", "+x", "/compile.sh"]

ENTRYPOINT ["/compile.sh"]
