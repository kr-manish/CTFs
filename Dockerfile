# ========== Build stage ===========
FROM parrotsec/security:latest

LABEL maintainer="Manish Kumar"
ENV DEBIAN_FRONTEND=noninteractive

# Install Essentials
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    build-essential \
    gcc net-tools \
    vim neovim \
    openjdk-17-jdk \
    make ruby nodejs npm cmake \
    x11-apps \
    wireshark \
    git \
    ca-certificates \
    curl \
    sqlite3 \
    whois \
    wget zip unzip nmap \
    python3-pip python3-dev python3-venv \
    perl gdb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Zsteg (Ruby gem)
RUN gem install zsteg


RUN set -e && \
  mkdir targets && \
  mkdir results && \
  mkdir tools

RUN python3 -m venv /opt/ctfenv && \
    /opt/ctfenv/bin/pip install --upgrade pip && \
    /opt/ctfenv/bin/pip install pwntools ropper one_gadget requests flask beautifulsoup4 scrapy ipython

# RUN cd tools
WORKDIR /tools

# Installing Feroxbuster
RUN curl -sLO https://github.com/epi052/feroxbuster/releases/latest/download/feroxbuster_amd64.deb.zip
RUN unzip feroxbuster_amd64.deb.zip
RUN apt install ./feroxbuster_*_amd64.deb
RUN rm feroxbuster_amd64.deb.zip feroxbuster_*_amd64.deb 

# Installing Seclists
RUN git clone https://github.com/danielmiessler/SecLists.git

# Installing Go and amass
RUN wget -c https://go.dev/dl/go1.22.0.linux-amd64.tar.gz && \
    tar -C /usr/local/ -xzf go1.22.0.linux-amd64.tar.gz && \
    rm go1.22.0.linux-amd64.tar.gz
ENV PATH="${PATH}:/usr/local/go/bin"
RUN go install -v github.com/owasp-amass/amass/v4/...@master

RUN go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
RUN go install github.com/tomnomnom/assetfinder@latest
RUN go install github.com/tomnomnom/httprobe@latest
RUN go install github.com/tomnomnom/waybackurls@latest

# Installing massDns
RUN git clone https://github.com/blechschmidt/massdns.git  && cd massdns && make

# Installing massScan
RUN git clone https://github.com/robertdavidgraham/masscan && cd masscan && make
ENV PATH="${PATH}:/root/go/bin/:/tools/massdns/bin/:/tools/masscan/bin/"

# Radare2
RUN git clone https://github.com/radareorg/radare2.git --depth 1 && \
    cd radare2 && ./sys/install.sh

# Metasploit
# RUN curl https://raw.githubusercontent.com/rapid7/metasploit-framework/master/docker/metasploitframework/scripts/metasploit-framework-installer.sh | bash
RUN curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  chmod 755 msfinstall && \
  ./msfinstall

# Ghidra
# RUN wget https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.4.2_build/ghidra_10.4.2_PUBLIC_20240326.zip && \
#    unzip ghidra_10.4.2_PUBLIC_20240326.zip -d /opt && \
#    rm ghidra_10.4.2_PUBLIC_20240326.zip
# ENV PATH="/opt/ghidra_10.4.2_PUBLIC:${PATH}"

# Burp Suite (Community Edition)
# RUN mkdir -p /opt/burp && \
#    wget https://portswigger-cdn.net/burp/releases/community/latest/burp-suite-community-latest.jar -O /opt/burp/burpsuite.jar
# ENV PATH="/opt/burp:${PATH}"
RUN apt-get install burpsuite

# GUI support
ENV DISPLAY=host.docker.internal:0

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
