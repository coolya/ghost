#
# Ghost Dockerfile
#
# https://github.com/dockerfile/ghost
#

# Pull base image.
FROM node:argon-slim
RUN apt-get update 
RUN apt-get install -y zip unzip
# Install Ghost
RUN \
  cd /tmp && \
  wget https://ghost.org/zip/ghost-0.11.4.zip && \
  unzip ghost-0.11.4.zip -d /ghost && \
  rm -f ghost-0.11.4.zip && \
  cd /ghost && \
  npm install --production && \
  sed 's/127.0.0.1/0.0.0.0/' /ghost/config.example.js > /ghost/config.js && \
  useradd ghost --home /ghost && \
  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false zip unzip && \
  npm cache clean && \
  rm -rf /tmp/npm*

# Add files.
ADD start.bash /ghost-start

# Set environment variables.
ENV NODE_ENV production

# Define mountable directories.
VOLUME ["/data", "/ghost-override"]

# Define working directory.
WORKDIR /ghost

# Define default command.
CMD ["bash", "/ghost-start"]

# Expose ports.
EXPOSE 2368
