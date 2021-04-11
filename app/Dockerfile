FROM androidsdk/android-30:latest

# add nodejs 15 repo
RUN curl -fsSL https://deb.nodesource.com/setup_15.x | bash -

RUN apt-get update && \
    apt-get install -y \
    g++ \
    make \
    python \
    nodejs \
    && rm -rf /var/lib/apt/lists/* /tmp/*

RUN apt-get install -y nodejs

ENV ANDROID_HOME=/opt/android-sdk-linux
ENV PATH=$PATH:$ANDROID_HOME/platform-tools

RUN npm install -g nativescript yarn

COPY package.json yarn.lock /src/

COPY . /src/

WORKDIR /src

RUN yarn
