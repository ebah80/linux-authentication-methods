# Use the latest AlmaLinux base image
FROM almalinux:latest

# Install necessary packages
RUN dnf install epel-release -y && \
    dnf update -y && \
    dnf install -y \
    openssh-server \
    pam_yubico \
    passwd \
    sudo &&\
    dnf clean all &&\
    ssh-keygen -A

# Create a non-root user
RUN useradd -m -s /bin/bash -G wheel yubicouser

# Configure SSH
RUN mkdir -p /var/run/sshd

# Configure yubico
RUN mkdir -p /etc/yubico && \
    chmod 755 /etc/yubico && \
    echo "yubicouser:abcdefghijkl" | tee -a /etc/yubico/authorized_yubikeys && \
    chmod 644 /etc/yubico/authorized_yubikeys



# Enable Google Authenticator in PAM
COPY yubico-full/etc/pam.d/sshd /etc/pam.d/sshd
COPY yubico-full/etc/pam.d/sudo /etc/pam.d/sudo

# Configure SSH for yubico
COPY yubico-full/etc/ssh/sshd_config /etc/ssh/sshd_config
COPY yubico-full/etc/ssh/sshd_config.d/50-redhat.conf /etc/ssh/sshd_config.d/50-redhat.conf

# Expose SSH port
EXPOSE 22

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]
