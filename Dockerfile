FROM instast/debian-minbase
MAINTAINER Ye Liu <yeliu@instast.com>
COPY start.sh /opt/start.sh
RUN \
    useradd -m -s /bin/bash git && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install git openssh-server -y && \
    sed -i 's/PermitRootLogin\s\+without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/session\s\+required\s\+pam_loginuid.so/session optional pam_loginuid.so/' /etc/pam.d/sshd && \
    su -c 'git clone git://github.com/sitaramc/gitolite && mkdir bin && gitolite/install -ln ~/bin' - git
VOLUME ["/home/git/repositories"]
EXPOSE 22
CMD ["/bin/bash", "/opt/start.sh"]