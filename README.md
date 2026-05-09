# OpenCloud

OpenCloud is a fork of [opencloud-eu/opencloud](https://github.com/opencloud-eu/opencloud), a cloud-native content collaboration platform.

## Overview

OpenCloud provides a modern, scalable platform for file sync and share, built on top of open standards and protocols.

## Prerequisites

- Go 1.21 or later
- Docker (for containerized development)
- `buf` (for protobuf generation)
- `bingo` (for Go tool management)

## Getting Started

### Install Development Tools

This project uses [bingo](https://github.com/bwplotka/bingo) to manage Go-based development tools.

```bash
# Install bingo
go install github.com/bwplotka/bingo@latest

# Install all project tools
bingo get
```

### Build

```bash
make build
```

### Test

```bash
make test
```

### Run Locally (without Docker)

```bash
# Useful for quick iteration during development
make build && ./bin/opencloud server
```

### Generate Protobuf

```bash
make generate
```

## Project Structure

```
opencloud/
├── .bingo/          # Go tool version management
├── Makefile         # Build and development targets
└── README.md        # This file
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feat/my-feature`)
3. Commit your changes following [Conventional Commits](https://www.conventionalcommits.org/)
4. Push to your branch and open a Pull Request

### Backporting

This project uses automated backporting via `.backportrc.json`. To backport a merged PR, add the appropriate `backport/<branch>` label.

## Personal Notes

> This is my personal fork used for learning and experimentation. Changes here are not intended for upstream. See the [original repo](https://github.com/opencloud-eu/opencloud) for the canonical source.
>
> **Dev tip:** I run the local server with `OPENCLOUD_LOG_LEVEL=debug` set in my environment to get verbose output while experimenting.
>
> **Dev tip:** When iterating on storage changes, I also set `OPENCLOUD_STORAGE_HOME_DRIVER=ocis` explicitly to avoid surprises from environment defaults on my machine.
>
> **Dev tip:** I keep a local `.envrc` (via [direnv](https://direnv.net/)) in the repo root with all the above vars so I don't have to set them manually each session. Add `.envrc` to your global gitignore to avoid accidentally committing it.
>
> **Dev tip:** Running `make test` can be slow on the full suite. Use `go test ./path/to/package/...` to target just the package you're working on for faster feedback loops.
>
> **Dev tip:** If the local server port conflicts with something else on my machine, set `OPENCLOUD_HTTP_ADDR=0.0.0.0:9200` (or another free port) to override the default.

## License

Apache License 2.0 — see [LICENSE](LICENSE) for details.
