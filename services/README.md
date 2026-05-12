# OpenCloud Services

This directory contains the individual microservices that make up the OpenCloud platform.

## Architecture

OpenCloud is built as a collection of loosely coupled microservices, each responsible for a specific domain of functionality. Services communicate via gRPC and/or HTTP REST APIs.

## Available Services

| Service | Description | Port |
|---------|-------------|------|
| `auth-basic` | Basic authentication provider | 9146 |
| `auth-bearer` | Bearer token authentication | 9148 |
| `frontend` | HTTP frontend / gateway | 9140 |
| `gateway` | CS3 gateway service | 9142 |
| `graph` | Microsoft Graph API compatibility | 9120 |
| `idm` | Identity management | 9235 |
| `idp` | Identity provider (OIDC) | 9130 |
| `nats` | NATS messaging service | 9233 |
| `notifications` | Notification service | 9174 |
| `ocdav` | OC WebDAV service | 9163 |
| `search` | Full-text search service | 9220 |
| `settings` | Settings management | 9190 |
| `sharing` | Share management | 9150 |
| `storage-publiclink` | Public link storage | 9178 |
| `storage-shares` | Shares storage | 9154 |
| `storage-system` | System storage | 9215 |
| `storage-users` | User storage | 9157 |
| `thumbnails` | Image thumbnail generation | 9185 |
| `userlog` | User activity log | 9210 |
| `users` | User management | 9144 |
| `web` | Web frontend assets | 9100 |
| `webdav` | WebDAV proxy | 9115 |
| `webfinger` | WebFinger discovery | 9280 |

## Development

### Running a Single Service

```bash
go run ./services/<service-name>/main.go server
```

### Building All Services

```bash
make build
```

### Running Tests

```bash
make test
```

## Configuration

Each service can be configured via:
1. Environment variables (highest priority)
2. Configuration file (`config.yaml`)
3. Default values

See individual service documentation for available configuration options.

## Adding a New Service

1. Create a new directory under `services/`
2. Implement the service interface
3. Register the service in the main `opencloud` binary
4. Add configuration defaults
5. Write unit and integration tests
6. Update this README
