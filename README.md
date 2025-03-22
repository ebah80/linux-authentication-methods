# Linux authentication methods


Dockerfile                                | Authentication1 | Authentication2 | sudo |
------------------------------------------|-----------------|-----------------|---------------|
password-authentication.dockerfile       | Password             | -               | passwordless             |
sshkey.dockerfile       | sshkey             | -               | -             |
password+sshkey.dockerfile       | sshkey             | Password               | -             |
google-authenticator.dockerfile       | OTP             | -               | passwordless             |
google-authenticator-password.dockerfile  | OTP             | -               | Password      | 
google-authenticator-sshkey.dockerfile    | OTP             | SSH-KEY         | Password      |
google-authenticator-full.dockerfile      | OTP             | -               | OTP           |
yubikey.dockerfile                         | yubikey          | Password        | -             |
yubikey-sshkey.dockerfile                  | yubikey          | SSH-KEY         | -             |
yubico-full.dockerfile                    | yubikey          | -               | yubikey        |

## password-authentication.dockerfile
```
docker build -t password-authentication -f password-authentication.dockerfile .

docker run -d --name password-authentication-container \
    -p 2222:22 password-authentication

ssh otpuser@localhost -p 2222

# Free resources
docker kill password-authentication-container

## Troubleshooting

# Enter the container skipping CMD ["/usr/sbin/sshd", "-D"]
docker run --rm -it -p 2222:22 password-authentication bash

# Run sshd in debug mode in the container to track what happens
/usr/sbin/sshd -D -d
/usr/sbin/sshd -D -e
```

## sshkey.dockerfile
... work in progress ...

## password+sshkey.dockerfile
... work in progress ...

## google-authenticator.dockerfile

```
docker build -t google-authenticator -f google-authenticator.dockerfile .

docker run -d --name google-authenticator-container \
    -v ./google-authenticator/home/otpuser:/home/otpuser \
    -p 2222:22 google-authenticator

# First time configuration
docker exec -it google-authenticator-container bash
su - otpuser
google-authenticator

# Test
ssh otpuser@localhost -p 2222

# Free resources
docker kill google-authenticator-container

## Troubleshooting

# Enter the container skipping CMD ["/usr/sbin/sshd", "-D"]
# docker run --rm -it -v /workspace/linux-google-authenticator/google-authenticator/home/otpuser:/home/otpuser -p 2222:22 google-authenticator bash

# Run sshd in debug mode in the container
# /usr/sbin/sshd -D -d
# /usr/sbin/sshd -D -e
```
## google-authenticator-password.dockerfile
... work in progress ...

## google-authenticator-sshkey.dockerfile
... work in progress ...

## google-authenticator-full.dockerfile

```
docker build -t google-authenticator-full -f google-authenticator-full.dockerfile .

docker run -d --name google-authenticator-full-container \
    -v ./google-authenticator-full/home/otpuser:/home/otpuser \
    -p 2222:22 google-authenticator-full

# First time configuration
docker exec -it google-authenticator-full-container bash
su - otpuser
google-authenticator

# Test
ssh otpuser@localhost -p 2222

# Free resources
docker kill google-authenticator-full-container

## Troubleshooting

# Enter the container skipping CMD ["/usr/sbin/sshd", "-D"]
# docker run --rm -it -v ./google-authenticator/home/otpuser:/home/otpuser -p 2222:22 google-authenticator-full bash

# Run sshd in debug mode in the container
# /usr/sbin/sshd -D -d
# /usr/sbin/sshd -D -e
```

## Yubikey + password
... work in progress ...

## Yubikey + ssh-key
... work in progress ...

## Yubikey authentication +  Yubikey authorization (sudo)
... work in progress ...
