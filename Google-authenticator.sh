#!/bin/bash
docker build -t almalinux-otp -f Google-authenticator.Dockerfile .
docker run -d --name otp-container -p 2222:22 almalinux-otp
docker exec -it otp-container bash
ssh otpuser@localhost -p 2222