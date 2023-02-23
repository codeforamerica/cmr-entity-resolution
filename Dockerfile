FROM senzing/senzingapi-runtime:3.4.1 AS configs

FROM ubuntu:latest

# Required in order to bypass the license prompt.
ENV SENZING_ACCEPT_EULA="I_ACCEPT_THE_SENZING_EULA"
ENV TERM=xterm

# Update packages and install additional dependencies.
RUN apt update && \
    apt upgrade -y && \
    apt install -y \
      apt-transport-https \
      apt-utils \
      gnupg \
      libpq-dev \
      postgresql-client \
      python3-pip \
      wget

# The senzing API requires libssl1.1, but it's not available by default.
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb && \
    apt install -y ./libssl1.1_1.1.0g-2ubuntu4_amd64.deb && \
    rm ./libssl1.1_1.1.0g-2ubuntu4_amd64.deb

# Add the senzing repo and install the API.
RUN wget https://senzing-production-apt.s3.amazonaws.com/senzingrepo_1.0.0-1_amd64.deb && \
    apt install -y ./senzingrepo_1.0.0-1_amd64.deb && \
    apt update && \
    apt install -y senzingapi && \
    rm ./senzingrepo_1.0.0-1_amd64.deb

# Clean up.
RUN apt autoremove && apt clean

# Copy the configurations from the senzingapi-runtime image.
COPY --from=configs /etc/opt/senzing /etc/opt/senzing

# Add a new user and switch to it.
RUN useradd -m -u 1001 senzing
USER senzing

# Set environment variables for the senzing user.
ENV LD_LIBRARY_PATH=/opt/senzing/g2/lib:/opt/senzing/g2/lib/debian
ENV PATH=${PATH}:/opt/senzing/g2/python
ENV SENZING_API_SERVER_BIND_ADDR=all

RUN pip3 install psycopg2 --user

WORKDIR /home/senzing
