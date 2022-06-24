#Based on https://github.com/hexops/dockerfile (modified Luigi C/Squeige 6/20)
FROM node:lts-alpine3.15 AS dev_img

# Static GID/UID is also useful for chown'ing files outside the container where
# such a user does not exist.
RUN addgroup --gid 10001 --system ssh \
 && adduser  --uid 10000 --system --ingroup ssh --home /home/ssh ssh -s /bin/sh 

# Tini allows us to avoid several Docker edge cases, see https://github.com/krallin/tini.
# NOTE: See https://github.com/hexops/dockerfile#is-tini-still-required-in-2020-i-thought-docker-added-it-natively
# bind-tools is needed for DNS resolution to work in *some* Docker networks, but not all.
# This applies to nslookup, Go binaries, etc. If you want your Docker image to work even

#Install required applciations for this docker dev env.
RUN apk update && \
apk add --no-cache \ 
	tini \
	android-tools \
	openssh-server \
	bind-tools

RUN ssh-keygen -A
RUN npm install --location=global expo-cli
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
#setup default ssh password.
ARG SSHPASS=12345
RUN echo "ssh:${SSHPASS}" | chpasswd

# Well need to expose some ports so that the host can open Expo
EXPOSE 19001 19002 19006 22

# The Following line is needed since by default Expo uses 127.0.0.1/localhost these are defaults, for using with docker build, docker expose uses the ones in .env
ENV EXPO_DEVTOOLS_LISTEN_ADDRESS=0.0.0.0
ENV REACT_NATIVE_PACKAGER_HOSTNAME="192.168.1.28"

WORKDIR /var/www
COPY ./scripts/startup.sh /opt/scripts/

#Entry point defines the main running process.
ENTRYPOINT ["/sbin/tini", "--" , "/bin/sh" ]

#Since we want to enable ssh to use editors with those capabilities, and the whole idea microservices is to run one process per container we will need to use a script as an entrypoint so that we can run more than one process at a time.
#For security purposes I have decide that upon start ssh will not be running meaning only docker exec can jump in the box, once needed user will only need to go and execute the startup script provided in /opt/scripts/startup.sh
#All settings/password and other information is being set here at default and gets overriden by the ARGS and env data in the docker compose .env file.
