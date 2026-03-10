<h1 align="center">
    <br>
    <a href="https://timecrack.org">
        <img src="https://raw.githubusercontent.com/alextselegidis/timecrack/main/logo.png" alt="Timecrack" width="150">
    </a>
    <br>
    Timecrack Docker
    <br>
</h1>

<br>

<h4 align="center">
    A powerful Open Source Time Tracking application that can be installed on your server. 
</h4>

<p align="center">
  <img alt="GitHub" src="https://img.shields.io/github/license/alextselegidis/timecrack?style=for-the-badge">
  <img alt="GitHub release (latest by date)" src="https://img.shields.io/github/v/release/alextselegidis/timecrack?style=for-the-badge">
  <img alt="GitHub All Releases" src="https://img.shields.io/github/downloads/alextselegidis/timecrack/total?style=for-the-badge">
</p>

<p align="center">
  <a href="#about">About</a> •
  <a href="#features">Features</a> •
  <a href="#setup">Setup</a> •
  <a href="#environment-variables">Environment Variables</a> •
  <a href="#license">License</a>
</p>

## About

**Timecrack** is a time tracking application, designed for simplicity and efficiency. It lets you define your projects 
and tasks, and then track the time you spend on them. You can also add notes to your time entries, and view reports of 
your time usage.

This Docker image is built on **PHP 8.2 with Apache** and is designed to run the Laravel-based Timecrack application.
On container startup, the entrypoint script automatically generates the Laravel `.env` file from Docker environment 
variables, runs database migrations, and caches the configuration for optimal performance.

## Features

The application allows you to manage and organize your time trackings.

- Clean & minimal interface
- Tagging & search
- Self-hosted (Docker support)
- Multi-user capable (future/planned)
- No tracking / no ads

## Setup

To clone and run this application, you'll need [Docker](https://docs.docker.com/get-docker/) installed on your computer. From your command line:

```bash
# Start a MySQL instance
docker run -d --name timecrack-db \
  -e MYSQL_ROOT_PASSWORD=secret \
  -e MYSQL_DATABASE=timecrack \
  mysql:8.0

# Pull and run the app
docker run -d --name timecrack-app \
  --link timecrack-db:db \
  -p 80:80 \
  -e APP_URL=http://localhost \
  -e DB_HOST=db \
  -e DB_DATABASE=timecrack \
  -e DB_USERNAME=root \
  -e DB_PASSWORD=secret \
  alextselegidis/timecrack:latest
```

## Docker Compose

You can use the following `docker-compose.yml` file to locally set up Timecrack with a MySQL database: 

```yaml
services:

  timecrack:
    image: alextselegidis/timecrack:latest
    restart: always
    ports:
      - '80:80'
    environment:
      - APP_NAME=Timecrack
      - APP_ENV=production
      - APP_DEBUG=false
      - APP_URL=http://localhost
      - DB_CONNECTION=mysql
      - DB_HOST=mysql
      - DB_PORT=3306
      - DB_DATABASE=timecrack
      - DB_USERNAME=root
      - DB_PASSWORD=secret
      - MAIL_MAILER=smtp
      - MAIL_HOST=smtp.example.org
      - MAIL_PORT=587
      - MAIL_USERNAME=
      - MAIL_PASSWORD=
      - MAIL_ENCRYPTION=tls
      - MAIL_FROM_ADDRESS=info@example.org
      - MAIL_FROM_NAME=Timecrack
    volumes:
      - timecrack-storage:/var/www/html/storage

  mysql:
    image: mysql:8.0
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=secret
      - MYSQL_DATABASE=timecrack
    volumes:
      - mysql:/var/lib/mysql

volumes:
  timecrack-storage:
  mysql:
```

## Environment Variables

The Docker image uses standard Laravel environment variables. All variables are passed through to the `.env` file that is generated on container startup.

### Application

| Variable | Default | Description |
|---|---|---|
| `APP_NAME` | `Timecrack` | Application name |
| `APP_ENV` | `production` | Application environment (`production`, `local`, `testing`) |
| `APP_KEY` | *(auto-generated)* | Application encryption key. If left empty, one is generated automatically on first start |
| `APP_DEBUG` | `false` | Enable debug mode (`true` / `false`) |
| `APP_URL` | `http://localhost` | The public URL of the application |

### Logging

| Variable | Default | Description |
|---|---|---|
| `LOG_CHANNEL` | `stack` | Laravel log channel (`stack`, `single`, `daily`, `stderr`, etc.) |
| `LOG_LEVEL` | `error` | Minimum log level (`debug`, `info`, `notice`, `warning`, `error`, `critical`) |

### Database

| Variable | Default | Description |
|---|---|---|
| `DB_CONNECTION` | `mysql` | Database driver (`mysql`, `pgsql`, `sqlite`) |
| `DB_HOST` | `db` | Database hostname |
| `DB_PORT` | `3306` | Database port |
| `DB_DATABASE` | `timecrack` | Database name |
| `DB_USERNAME` | `root` | Database username |
| `DB_PASSWORD` | `secret` | Database password |

### Cache & Session

| Variable | Default | Description |
|---|---|---|
| `CACHE_DRIVER` | `file` | Cache driver (`file`, `redis`, `memcached`, `database`) |
| `SESSION_DRIVER` | `file` | Session driver (`file`, `redis`, `database`, `cookie`) |
| `SESSION_LIFETIME` | `120` | Session lifetime in minutes |
| `QUEUE_CONNECTION` | `sync` | Queue connection (`sync`, `redis`, `database`) |
| `BROADCAST_DRIVER` | `log` | Broadcast driver (`log`, `redis`, `pusher`) |
| `FILESYSTEM_DISK` | `local` | Default filesystem disk |

### Redis

| Variable | Default | Description |
|---|---|---|
| `REDIS_HOST` | `127.0.0.1` | Redis hostname |
| `REDIS_PASSWORD` | `null` | Redis password |
| `REDIS_PORT` | `6379` | Redis port |

### Mail

| Variable | Default | Description |
|---|---|---|
| `MAIL_MAILER` | `smtp` | Mail driver (`smtp`, `sendmail`, `mailgun`, `ses`, `log`) |
| `MAIL_HOST` | `mailpit` | SMTP hostname |
| `MAIL_PORT` | `1025` | SMTP port |
| `MAIL_USERNAME` | `null` | SMTP username |
| `MAIL_PASSWORD` | `null` | SMTP password |
| `MAIL_ENCRYPTION` | `null` | SMTP encryption (`tls`, `ssl`, or `null`) |
| `MAIL_FROM_ADDRESS` | `hello@example.com` | Sender email address |
| `MAIL_FROM_NAME` | `Timecrack` | Sender name |

## Startup Behavior

On every container start the entrypoint script will:

1. Generate the Laravel `.env` file from the Docker environment variables.
2. Set correct permissions on `storage/` and `bootstrap/cache/`.
3. Auto-generate an `APP_KEY` if one was not provided.
4. Run `php artisan migrate --force` to apply pending database migrations.
5. Create the `storage:link` symbolic link.
6. Cache configuration, routes, and views for performance.
7. Start the Apache web server.

## License 

Code Licensed Under [GPL v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html) | Content Under [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/)

---

Website [alextselegidis.com](https://alextselegidis.com) &nbsp;&middot;&nbsp;
GitHub [alextselegidis](https://github.com/alextselegidis) &nbsp;&middot;&nbsp;
Twitter [@alextselegidis](https://twitter.com/AlexTselegidis)
