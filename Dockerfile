# hadolint global ignore=DL3008,DL3013,DL3016,DL3059
# - DL3008: Pin versions in apt get install
# - DL3013: Pin versions in pip install
# - DL3016: Pin versions in npm install
# - DL3059: Multiple consecutive `RUN` instructions
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND noninteractive

SHELL [ "/bin/bash", "-o", "pipefail", "-c" ]

# common packages
RUN apt-get update && apt-get install -y \
    --no-install-recommends \
    apt-utils \
    curl \
    git \
    gnupg \
    software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# npm
RUN curl -fsSL https://deb.nodesource.com/setup_23.x | bash - \
    && apt-get install -y \
    --no-install-recommends \
    nodejs
ENV PATH "/usr/lib/node_modules:${PATH}"

# Rust
RUN curl -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH "/root/.cargo/bin:${PATH}"

# Haskell
RUN apt-get install -y \
    --no-install-recommends \
    cabal-install
ENV PATH "/root/.cabal/bin/:${PATH}"

# go
RUN apt-get install -y \
    --no-install-recommends \
    golang-go
ENV PATH "/root/go/bin/:${PATH}"

# .md
# - (formatter) markdownlint
# - (linter)    markdownlint
RUN npm install -g markdownlint-cli

# .py
# - (formatter) isort
# - (formatter) black
# - (linter)    flake8
# - (linter)    mypy
RUN apt-get install -y \
    --no-install-recommends \
    python3 \
    python3-pip
RUN pip3 install --no-cache-dir --break-system-package isort black flake8 mypy

# .sh
# - (formatter) shfmt
# - (linter)    shellcheck
RUN apt-get install -y \
    --no-install-recommends \
    shfmt \
    shellcheck

# .toml
# - (formatter) taplo
# - (linter)    taplo
RUN cargo install taplo-cli

# .yaml
# - (formatter) yamlfmt
# - (linter)    N/A
RUN go install github.com/google/yamlfmt/cmd/yamlfmt@latest

# .json
# - (formatter) js-beautify
# - (linter)    N/A
RUN npm install -g js-beautify

# .js
# - (formatter) eslint
# - (linter)    eslint
RUN npm install -g eslint
RUN npm install -g @stylistic/eslint-plugin-js

# Dockerfile
# - (formatter) -
# - (linter)    hadolint
RUN curl -fsSL https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64 -o /usr/local/bin/hadolint \
    && chmod +x /usr/local/bin/hadolint
ENV PATH "/usr/local/bin/:${PATH}"

# +x for node_modules
RUN chmod -R +x /usr/lib/node_modules/*

# check installed versions
RUN markdownlint --version
RUN isort --version
RUN black --version
RUN flake8 --version
RUN mypy --version
RUN shfmt --version
RUN shellcheck --version
RUN taplo --version
RUN yamlfmt --version
RUN js-beautify --version
RUN eslint --version
RUN hadolint --version

# open for all users
RUN chmod -R 777 /root

CMD ["/bin/bash"]
