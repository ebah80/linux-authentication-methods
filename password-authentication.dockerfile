# Use the latest AlmaLinux base image
FROM almalinux:latest

# Install necessary packages
RUN dnf install epel-release -y && \
    dnf update -y && \
    dnf install -y \
    openssh-server \
    google-authenticator \
    passwd \
    sudo &&\
    dnf clean all &&\
    ssh-keygen -A

# Create a non-root user (change "otpuser" to your preferred username)
RUN useradd -m -s /bin/bash otpuser && echo "otpuser:temporarypassword" | chpasswd

# Configure SSH
RUN mkdir -p /var/run/sshd

# Allow passwordless sudo for the test user (optional)
RUN echo 'otpuser ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/otpuser

# Expose SSH port
EXPOSE 22

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]
