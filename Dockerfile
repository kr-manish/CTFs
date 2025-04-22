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
    gobuster nikto hydra file ltrace strace libc6 netdiscover openvpn iproute2 iputils-ping \
    ruby-dev build-essential nbtscan smbmap smbclient enum4linux samba-client pure-ftpd \ 
    ldap-utils python3-impacket && gem install wpscan && gem install evil-winrm \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Zsteg (Ruby gem)
RUN gem install zsteg

RUN set -e && \
  mkdir targets && \
  mkdir results && \
  mkdir tools

RUN python3 -m venv /opt/ctfenv && \
    /opt/ctfenv/bin/pip install --upgrade pip && \
    /opt/ctfenv/bin/pip install pwntools pypykatz ropper one_gadget requests flask beautifulsoup4 scrapy ipython hashid

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
RUN go install github.com/ffuf/ffuf/v2@latest
RUN go install github.com/ropnop/kerbrute@latest
RUN go install github.com/jpillora/chisel@latest

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

# EyeWitness
RUN git clone https://github.com/RedSiege/EyeWitness.git /tools/eye && \
    bash -c "source /opt/ctfenv/bin/activate && /tools/eye/Python/setup/setup.sh"

# Clone and install CrackMapExec
RUN git clone --recursive https://github.com/Porchetta-Industries/CrackMapExec.git /tools/CrackMapExec && \
    cd /tools/CrackMapExec && /opt/ctfenv/bin/pip install .

# SQLmap
RUN git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git /tools/sqlmap && \
    ln -s /tools/sqlmap/sqlmap.py /usr/bin/sqlmap

# Install Microsoft dependencies and PowerShell
RUN apt-get install -y wget apt-transport-https software-properties-common && \
    wget -q https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell && \
    rm packages-microsoft-prod.deb

# hashcat
RUN git clone https://github.com/hashcat/hashcat.git && cd hashcat && make && make install

# John
RUN git clone https://github.com/magnumripper/JohnTheRipper.git /tools/john && \
    cd /tools/john/src && ./configure && make -s clean && make -sj2
ENV PATH="/tools/john/run:${PATH}"

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
