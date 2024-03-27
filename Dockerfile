FROM rust

ENV DOCKER_CONTENT_TRUST=1
ENV SQLX_OFFLINE true
ENV APP_ENVIRONMENT production

WORKDIR /app

RUN apt update && apt install lld clang -y

COPY --chown=app:app . /app
# COPY . .

RUN cargo build --release

ENTRYPOINT ["./target/release/zero2prod"]


