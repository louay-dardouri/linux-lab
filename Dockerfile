FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    openssh-server sudo curl vim nano man-db less wget \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

COPY linux-lab.sh /usr/local/bin/linux-lab.sh
COPY users.txt /tmp/users.txt

RUN chmod +x /usr/local/bin/linux-lab.sh

RUN while IFS=: read -r username password; do \
    useradd -m -s /bin/bash "$username" && \
    echo "$username:$password" | chpasswd && \
    usermod -aG sudo "$username" ; \
    done < /tmp/users.txt

# SSH config: allow password login, disable root login
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]
