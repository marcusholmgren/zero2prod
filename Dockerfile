# Builder stage
FROM rust as builder

WORKDIR /app

RUN apt update && apt install lld clang -y

COPY . .
#COPY --chown=app:app . /app

ENV DOCKER_CONTENT_TRUST=1
ENV SQLX_OFFLINE true

RUN cargo build --release

# Runtime stage
FROM debian:bullseye-slim as runtime

WORKDIR /app

# Install OpenSSL - it is dynamically linked by some of our dependencies
# Install ca-certificates - it is needed to verify TLS certificates
# when establishing HTTPS connections
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends openssl ca-certificates \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

COPY --chown=app:app --from=builder /app/target/release/zero2prod zero2prod
COPY --chown=app:app configuration configuration

ENV APP_ENVIRONMENT production

ENTRYPOINT ["./zero2prod"]
