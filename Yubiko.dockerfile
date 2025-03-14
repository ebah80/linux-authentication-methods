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

# Create a non-root user (change "otpuser" to your preferred username)
RUN useradd -m -s /bin/bash otpuser && echo "otpuser:temporarypassword" | chpasswd

# Configure SSH
RUN mkdir -p /var/run/sshd

# Allow passwordless sudo for the test user (optional)
RUN echo 'otpuser ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/otpuser

# Enable Google Authenticator in PAM
RUN sed -i '2i auth required pam_google_authenticator.so' /etc/pam.d/sshd && \
    sed -i '/password-auth/s/^/# /' /etc/pam.d/sshd
#    sed -i '2i auth required pam_google_authenticator.so nullok' /etc/pam.d/password-auth

# Configure SSH to use keyboard-interactive authentication for OTP
RUN sed -i 's/^ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config.d/50-redhat.conf && \
    sed -i 's/^#KbdInteractiveAuthentication.*/KbdInteractiveAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    echo "AuthenticationMethods keyboard-interactive" >> /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 22

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]
