ARG BASE_IMAGE
FROM $BASE_IMAGE

ARG STACK
ARG GOOGLE_CHROME_CHANNEL
ARG GOOGLE_CHROME_SPECIFIC_VERSION

# Emulate the platform where root access is not available
RUN useradd -m -d /app non-root-user
RUN mkdir -p /app /cache /env
RUN chown non-root-user /app /cache /env
USER non-root-user

RUN [ -z "${GOOGLE_CHROME_CHANNEL}" ] || echo "${GOOGLE_CHROME_CHANNEL}" > /env/GOOGLE_CHROME_CHANNEL
RUN [ -z "${GOOGLE_CHROME_SPECIFIC_VERSION}" ] || echo "${GOOGLE_CHROME_SPECIFIC_VERSION}" > /env/GOOGLE_CHROME_SPECIFIC_VERSION
RUN [ -z echo "${}" > /env/GOOGLE_CHROME_SPECIFIC_VERSION
COPY --chown=non-root-user . /buildpack
WORKDIR /app

# Sanitize the environment seen by the buildpack, to prevent reliance on
# environment variables that won't be present when it's run by Heroku CI.
RUN env -i PATH=$PATH HOME=$HOME STACK=$STACK /buildpack/bin/detect /app
RUN env -i PATH=$PATH HOME=$HOME STACK=$STACK /buildpack/bin/compile /app /cache /env
