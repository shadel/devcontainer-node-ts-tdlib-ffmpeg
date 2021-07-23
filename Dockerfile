# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.187.0/containers/typescript-node/.devcontainer/base.Dockerfile

# [Choice] Node.js version: 16, 14, 12
ARG VARIANT="16-buster"
FROM mcr.microsoft.com/vscode/devcontainers/typescript-node:0-${VARIANT}

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment if you want to install an additional version of node using nvm
# ARG EXTRA_NODE_VERSION=10
# RUN su node -c "source /usr/local/share/nvm/nvm.sh && nvm install ${EXTRA_NODE_VERSION}"

# [Optional] Uncomment if you want to install more global node packages
# RUN su node -c "npm install -g <your-package-list -here>"
VOLUME ["/srv"]

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y make git zlib1g-dev libssl-dev gperf php-cli cmake g++
RUN git clone https://github.com/tdlib/td.git td && \
    cd td && \
    rm -rf build && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local ..  && \
    cmake --build . --target prepare_cross_compiling  && \
    cd ..  && \
    php SplitSource.php && \
    cd build && \
    cmake --build . --target install && \
    cd .. && \
    php SplitSource.php --undo
RUN ls -l /usr/local