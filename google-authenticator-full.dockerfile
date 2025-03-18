# Use the latest AlmaLinux base image
FROM almalinux:latest

# Install necessary packages
RUN dnf install epel-release -y && \
    dnf update -y && \
    dnf install -y \
    openssh-server \
    google-authenticator \
    passwd \
    nano \
    sudo &&\
    dnf clean all &&\
    ssh-keygen -A

# Create a non-root user without a password
RUN useradd -m -s /bin/bash -G wheel otpuser

# Configure SSH
RUN mkdir -p /var/run/sshd

# Enable Google Authenticator in PAM
COPY google-authenticator-full/etc/pam.d/sshd /etc/pam.d/sshd
COPY google-authenticator-full/etc/pam.d/sudo /etc/pam.d/sudo

# Configure SSH for OTP
COPY google-authenticator-full/etc/ssh/sshd_config /etc/ssh/sshd_config
COPY google-authenticator-full/etc/ssh/sshd_config.d/50-redhat.conf /etc/ssh/sshd_config.d/50-redhat.conf

# Expose SSH port
EXPOSE 22

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]
