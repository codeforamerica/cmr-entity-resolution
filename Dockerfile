# The ibm_db driver currently only supports x86_64 architecture, so we'll
# support that as the only option for now.
FROM --platform=linux/amd64 senzing/senzingapi-runtime:${SENZING_VERSION:-3.12.0} AS configs

FROM --platform=linux/amd64 ruby:${RUBY_VERSION:-3.3}

# Required in order to bypass the license prompt.
ENV SENZING_ACCEPT_EULA="I_ACCEPT_THE_SENZING_EULA"
ENV TERM=xterm
ENV SENZING_VERSION=${SENZING_VERSION:-3.12.0}

# Update packages and install additional dependencies.
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
      apt-transport-https \
      apt-utils \
      gnupg \
      libpq-dev \
      postgresql-client \
      python3-pip \
      python3-psycopg2 \
      wget

# Add the senzing repo and install the API.
# https://senzing.zendesk.com/hc/en-us/articles/115002408867-Quickstart-for-Linux
RUN wget https://senzing-production-apt.s3.amazonaws.com/senzingrepo_2.0.0-1_all.deb && \
    apt-get install -y ./senzingrepo_2.0.0-1_all.deb && \
    apt-get update && \
    apt-get install -y "senzingapi=$SENZING_VERSION*" && \
    rm ./senzingrepo_2.0.0-1_all.deb

# Clean up.
RUN apt-get autoremove && apt-get clean

# Copy the configurations from the senzingapi-runtime image.
COPY --from=configs /etc/opt/senzing /etc/opt/senzing

# Install the cli tooling.
COPY . /opt/cmr
WORKDIR /opt/cmr
RUN bundle install && bundle binstubs cmr-entity-resolution

# Add a new user and switch to it.
RUN useradd -m -u 1001 senzing
USER senzing

# Set environment variables for the senzing user.
ENV LD_LIBRARY_PATH=/opt/senzing/g2/lib:/opt/senzing/g2/lib/debian
ENV PATH=/opt/cmr/bin:${PATH}:/opt/senzing/g2/python
ENV RUBY_YJIT_ENABLE=true
ENV SENZING_API_SERVER_BIND_ADDR=all

WORKDIR /home/senzing

ENTRYPOINT ["/opt/cmr/scripts/entrypoint.sh"]
CMD run
