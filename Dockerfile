#Based on https://github.com/hexops/dockerfile (modified Luigi C 6/20)
#We suggest using the major.minor tag, not major.minor.patch.
FROM node:lts-alpine3.15 AS dev_img

# Non-root user for security purposes.
# UIDs below 10,000 are a security risk, as a container breakout could result
# in the container being ran as a more privileged user on the host kernel with
# the same UID.
#
# Static GID/UID is also useful for chown'ing files outside the container where
# such a user does not exist.
RUN addgroup --gid 10001 --system nonroot \
 && adduser  --uid 10000 --system --ingroup nonroot --home /home/nonroot nonroot -s /bin/sh 

# Tini allows us to avoid several Docker edge cases, see https://github.com/krallin/tini.
# NOTE: See https://github.com/hexops/dockerfile#is-tini-still-required-in-2020-i-thought-docker-added-it-natively
# bind-tools is needed for DNS resolution to work in *some* Docker networks, but not all.
# This applies to nslookup, Go binaries, etc. If you want your Docker image to work even

RUN apk update && \
apk add --no-cache \ 
	tini android-tools \
#	bind-tools \
#	android-tools \
	openssh \
	openssh-server

#RUN ssh-keygen -A
#RUN npm install --location=global expo-cli



# Well need to expose some ports so that the host can open Expo
ARG PORT=19006
ENV PORT $PORT
EXPOSE $PORT 19001 19002

#ENV REACT_NATIVE_PACKAGER_HOSTNAME="192.168.1.28"
# The Following line is needed since by default Expo uses 127.0.0.1/localhost
#ENV EXPO_DEVTOOLS_LISTEN_ADDRESS=0.0.0.0

#Entry point defines the main running process.
##CMD ["--foo", "1", "--bar=2"]
#Since we want to enable ssh to use editors with those capabilities, and the whole idea microservices is to run one process per container we will need to use a script as an entrypoint so that we can run more than one process at a time.
WORKDIR /var/www
COPY ./scripts/startup.sh /opt/myscripts/
#COPY ./scripts/sshd_config /etc/ssh/sshd_config
RUN echo nonroot:password | chpasswd

ENTRYPOINT ["/opt/myscripts/startup.sh" ]

# Use the non-root user to run our application
#USER nonroot
