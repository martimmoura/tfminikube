FROM rustlang/rust:latest-slim-buster as builder

WORKDIR /app

COPY Cargo.toml Cargo.lock ./

# This step is to cache dependencies
RUN mkdir src && echo "fn main() {}
" > src/main.rs
RUN cargo build --release

COPY src ./src

RUN cargo build --release

FROM debian:buster-slim

ARG APP_USER=appuser
RUN useradd $APP_USER

WORKDIR /app

COPY --from=builder /app/target/release/app ./

USER $APP_USER

EXPOSE 8080

CMD ["./app"]