FROM debian:jessie

ENV QEMU_VERSION #{QEMU_VERSION}
ENV QEMU_SHA256 #{QEMU_SHA256}

RUN apt-get -q update \
        && apt-get -qqy install \
                build-essential \
                zlib1g-dev \
                libpixman-1-dev \
                python \
                libglib2.0-dev \
                pkg-config \
                curl \
                jq \
        && rm -rf /var/lib/apt/lists/*

RUN #{CURL_COMMAND} \
	&& echo "${QEMU_SHA256}  qemu-${QEMU_VERSION}.tar.gz" > qemu-${QEMU_VERSION}.tar.gz.sha256sum \
	&& sha256sum -c qemu-${QEMU_VERSION}.tar.gz.sha256sum \
	&& mkdir /qemu-${QEMU_VERSION} \
	&& tar -xzf qemu-${QEMU_VERSION}.tar.gz -C /qemu-${QEMU_VERSION} --strip-components=1 \
	&& rm qemu-${QEMU_VERSION}.tar.gz*

WORKDIR /qemu-${QEMU_VERSION}

COPY . /qemu-${QEMU_VERSION}/

CMD ./build.sh
