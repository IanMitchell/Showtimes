#!/usr/bin/env bash

# Modified version of common-debian.sh
# https://github.com/microsoft/vscode-dev-containers

USERNAME=${1:-"automatic"}
USER_UID=${2:-"automatic"}
USER_GID=${3:-"automatic"}

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Load markers to see which steps have already run
MARKER_FILE="/usr/local/etc/vscode-dev-containers/common"
if [ -f "${MARKER_FILE}" ]; then
    echo "Marker file found:"
    cat "${MARKER_FILE}"
    source "${MARKER_FILE}"
fi

# Ensure apt is in non-interactive to avoid prompts
export DEBIAN_FRONTEND=noninteractive

# Run install apt-utils to avoid debconf warning then verify presence of other common developer tools and dependencies
if [ "${PACKAGES_ALREADY_INSTALLED}" != "true" ]; then
    PACKAGE_LIST="apt-utils \
        git \
        openssh-client \
        gnupg2 \
        iproute2 \
        procps \
        lsof \
        htop \
        net-tools \
        psmisc \
        curl \
        wget \
        rsync \
        ca-certificates \
        unzip \
        zip \
        nano \
        vim-tiny \
        less \
        jq \
        lsb-release \
        apt-transport-https \
        dialog \
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu[0-9][0-9] \
        liblttng-ust0 \
        libstdc++6 \
        zlib1g \
        locales \
        sudo \
        ncdu \
        man-db"

    # Install libssl1.1 if available
    if [[ ! -z $(apt-cache --names-only search ^libssl1.1$) ]]; then
        PACKAGE_LIST="${PACKAGE_LIST}       libssl1.1"
    fi

    # Install appropriate version of libssl1.0.x if available
    LIBSSL=$(dpkg-query -f '${db:Status-Abbrev}\t${binary:Package}\n' -W 'libssl1\.0\.?' 2>&1 || echo '')
    if [ "$(echo "$LIBSSL" | grep -o 'libssl1\.0\.[0-9]:' | uniq | sort | wc -l)" -eq 0 ]; then
        if [[ ! -z $(apt-cache --names-only search ^libssl1.0.2$) ]]; then
            # Debian 9
            PACKAGE_LIST="${PACKAGE_LIST}       libssl1.0.2"
        elif [[ ! -z $(apt-cache --names-only search ^libssl1.0.0$) ]]; then
            # Ubuntu 18.04, 16.04, earlier
            PACKAGE_LIST="${PACKAGE_LIST}       libssl1.0.0"
        fi
    fi

    echo "Packages to verify are installed: ${PACKAGE_LIST}"
    apt-get -y install --no-install-recommends ${PACKAGE_LIST} 2> >( grep -v 'debconf: delaying package configuration, since apt-utils is not installed' >&2 )

    PACKAGES_ALREADY_INSTALLED="true"
fi

# Get to latest versions of all packages
apt-get update
apt-get -y upgrade --no-install-recommends
apt-get autoremove -y

# Ensure at least the en_US.UTF-8 UTF-8 locale is available.
# Common need for both applications and things like the agnoster ZSH theme.
if [ "${LOCALE_ALREADY_SET}" != "true" ] && ! grep -o -E '^\s*en_US.UTF-8\s+UTF-8' /etc/locale.gen > /dev/null; then
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen
    LOCALE_ALREADY_SET="true"
fi

# Create or update a non-root user to match UID/GID.
if id -u ${USERNAME} > /dev/null 2>&1; then
    # User exists, update if needed
    if [ "${USER_GID}" != "automatic" ] && [ "$USER_GID" != "$(id -G $USERNAME)" ]; then
        groupmod --gid $USER_GID $USERNAME
        usermod --gid $USER_GID $USERNAME
    fi
    if [ "${USER_UID}" != "automatic" ] && [ "$USER_UID" != "$(id -u $USERNAME)" ]; then
        usermod --uid $USER_UID $USERNAME
    fi
else
    # Create user
    if [ "${USER_GID}" = "automatic" ]; then
        groupadd $USERNAME
    else
        groupadd --gid $USER_GID $USERNAME
    fi
    if [ "${USER_UID}" = "automatic" ]; then
        useradd -s /bin/bash --gid $USERNAME -m $USERNAME
    else
        useradd -s /bin/bash --uid $USER_UID --gid $USERNAME -m $USERNAME
    fi
fi

# Add add sudo support for non-root user
if [ "${USERNAME}" != "root" ] && [ "${EXISTING_NON_ROOT_USER}" != "${USERNAME}" ]; then
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
    chmod 0440 /etc/sudoers.d/$USERNAME
    EXISTING_NON_ROOT_USER="${USERNAME}"
fi

# ** Shell customization section **
if [ "${USERNAME}" = "root" ]; then
    USER_RC_PATH="/root"
else
    USER_RC_PATH="/home/${USERNAME}"
fi

# .bashrc/.zshrc snippet
RC_SNIPPET="$(cat << EOF
export USER=\$(whoami)

export PATH=\$PATH:\$HOME/.local/bin
EOF
)"

# code shim, it fallbacks to code-insiders if code is not available
cat << 'EOF' > /usr/local/bin/code
#!/bin/sh

get_in_path_except_current() {
  which -a "$1" | grep -v "$0" | head -1
}

code="$(get_in_path_except_current code)"

if [ -n "$code" ]; then
  exec "$code" "$@"
elif [ "$(command -v code-insiders)" ]; then
  exec code-insiders "$@"
else
  echo "code or code-insiders is not installed" >&2
  exit 127
fi
EOF
chmod +x /usr/local/bin/code

CODESPACES_ZSH="$(cat \
<<EOF
prompt() {
    if [ ! -z "\${GITHUB_USER}" ]; then
        local USERNAME="@\${GITHUB_USER}"
    else
        local USERNAME="%n"
    fi
    PROMPT="%{\$fg[green]%}\${USERNAME} %(?:%{\$reset_color%}➜ :%{\$fg_bold[red]%}➜ )"
    PROMPT+='%{\$fg_bold[blue]%}%~%{\$reset_color%} \$(git_prompt_info)%{\$fg[white]%}$ %{\$reset_color%}'
}
ZSH_THEME_GIT_PROMPT_PREFIX="%{\$fg_bold[cyan]%}(%{\$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{\$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{\$fg_bold[yellow]%}✗%{\$fg_bold[cyan]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{\$fg_bold[cyan]%})"
prompt
EOF
)"

# Optionally install and configure zsh and Oh My Zsh!
if ! type zsh > /dev/null 2>&1; then
    apt-get install -y zsh
fi
if [ "${ZSH_ALREADY_INSTALLED}" != "true" ]; then
    echo "${RC_SNIPPET}" >> /etc/zsh/zshrc
    ZSH_ALREADY_INSTALLED="true"
fi

# Install Node
if [ "${NODE_ALREADY_INSTALLED}" != "true" ]; then
    echo "Installing Volta"
    curl https://get.volta.sh | bash
    VOLTA_HOME="$HOME/.volta"
    PATH="$VOLTA_HOME/bin:$PATH"
    grep --silent "$VOLTA_HOME/bin" <<< $PATH || PATH="$VOLTA_HOME/bin:$PATH"

    echo "Installing Latest Node.js"
    volta install node@latest
    volta install npm-merge-driver
    NODE_ALREADY_INSTALLED="true"
fi

# Write marker file
mkdir -p "$(dirname "${MARKER_FILE}")"
echo -e "\
    PACKAGES_ALREADY_INSTALLED=${PACKAGES_ALREADY_INSTALLED}\n\
    LOCALE_ALREADY_SET=${LOCALE_ALREADY_SET}\n\
    EXISTING_NON_ROOT_USER=${EXISTING_NON_ROOT_USER}\n\
    NODE_ALREADY_INSTALLED=${NODE_ALREADY_INSTALLED}\n\
    ZSH_ALREADY_INSTALLED=${ZSH_ALREADY_INSTALLED}" > "${MARKER_FILE}"

echo "Done!"
