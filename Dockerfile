FROM ausimian/rocky9-otp25-elixir14-dev:1.0.1 AS fetcher

# 1.79.2
ARG  COMMIT=695af097c7bd098fbf017ce3ac85e09bbc5dda06
ARG  SERVER=server-linux-arm64

WORKDIR /tmp
ADD  https://update.code.visualstudio.com/commit:${COMMIT}/${SERVER}/stable ${SERVER}.tar.gz

WORKDIR /tmp/.vscode-server/bin/${COMMIT}
RUN  tar xzf /tmp/${SERVER}.tar.gz --strip-components 1 && \
     touch 0

FROM ausimian/rocky9-otp25-elixir14-dev:1.0.1

RUN  yum -y install git

WORKDIR /root
COPY --from=fetcher /tmp/.vscode-server /root/.vscode-server
RUN  .vscode-server/bin/695af097c7bd098fbf017ce3ac85e09bbc5dda06/bin/code-server --install-extension JakeBecker.elixir-ls
RUN  elixir .vscode-server/extensions/jakebecker.elixir-ls-0.15.2/elixir-ls-release/quiet_install.exs 

