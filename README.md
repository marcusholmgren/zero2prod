[![Rust](https://github.com/marcusholmgren/zero2prod/actions/workflows/general.yml/badge.svg)](https://github.com/marcusholmgren/zero2prod/actions/workflows/general.yml)
[![.github/workflows/audit.yml](https://github.com/marcusholmgren/zero2prod/actions/workflows/audit.yml/badge.svg)](https://github.com/marcusholmgren/zero2prod/actions/workflows/audit.yml)
# Zero to production

This application is a email newsletter service with features:
- unsubscribe
- managing multiple newletters
- segment subscribers into multiple audiences
- track opening and click rates

## Run Locally

You must have Rust installed local. Then you can compile and run the application with 

```bash
cargo run
```

## Container

Build a local version of the newsletter API with Docker or similar tool
```bash
docker build --tag zero2prod --file Dockerfile .  
```

### Docker Compose

The PostgreSQL database is exposed on the default port. Run the `sqlx` migration commands from the `scripts/init_db.sh` to create the required tables in the database.

## Tech Stack

- [Rust](https://www.rust-lang.org)
- [PostgreSQL](https://www.postgresql.org)
