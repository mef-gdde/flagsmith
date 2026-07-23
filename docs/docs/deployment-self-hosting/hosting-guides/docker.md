---
title: Docker
sidebar_label: Docker
description: Getting Started with Flagsmith on Docker
sidebar_position: 1
---

This guide explains how to run a full Flagsmith environment on your local machine using Docker. This is useful for development, testing, or evaluating Flagsmith's features.

You can use Docker to set up an entire [Flagsmith Feature Flag](https://www.flagsmith.com) environment locally:

```bash
curl -o docker-compose.yml https://raw.githubusercontent.com/Flagsmith/flagsmith/main/docker-compose.yml
docker-compose -f docker-compose.yml up
```

Wait for the images to download and run, then visit `http://localhost:8000/`. As a first step, you will need to create a new account at [http://localhost:8000/signup](http://localhost:8000/signup)

### Custom database and ports

The Compose file uses its bundled PostgreSQL database and exposes Flagsmith on ports `8000` and `8001` by default. Copy the provided `.env.example` to `.env`, then override the settings as needed:

```bash
cp .env.example .env
```

The same values can also be supplied as shell environment variables. For example, set `DATABASE_URL` to `postgresql://flagsmith:password@database.example.com:5432/flagsmith` to use an externally managed database.

`DATABASE_URL` configures both the migration and application services. `FLAGSMITH_PORT` and `FLAGSMITH_TASK_PROCESSOR_PORT` only change the ports published on the Docker host; both containers continue to listen on port `8000` internally.

Compose uses `dataef` as the global default network for every service and creates it automatically. To use an existing shared network instead, set `DATAEF_NETWORK_NAME` to its name and `DATAEF_NETWORK_EXTERNAL=true`. The external network must already exist.

Self-hosted Docker deployments allow unlimited projects per organisation by default. Set `MAX_PROJECTS_IN_FREE_PLAN` to a positive integer to enforce a limit; `0` means unlimited.

The Compose file builds the unified Flagsmith image from the checked-out source, ensuring fork-specific backend and frontend changes are included. Set `FLAGSMITH_IMAGE` to customise the resulting local image tag.

## Environment Variables

As well as the Environment Variables specified in the [API](/deployment-self-hosting/core-configuration/environment-variables#api-environment-variables) and [Frontend](/deployment-self-hosting/core-configuration/environment-variables#frontend-environment-variables), you can also specify the following:

- `GUNICORN_CMD_ARGS`: Gunicorn command line arguments. Overrides Flagsmith's defaults. See [Gunicorn documentation](https://docs.gunicorn.org/en/stable/settings.html) for reference.
- `GUNICORN_WORKERS`: The number of [Gunicorn Workers](https://docs.gunicorn.org/en/stable/settings.html#workers) that are created
- `GUNICORN_THREADS`: The number of [Gunicorn Threads per Worker](https://docs.gunicorn.org/en/stable/settings.html#threads)
- `GUNICORN_TIMEOUT`: The number of seconds before the [Gunicorn times out](https://docs.gunicorn.org/en/stable/settings.html#timeout)
- `ACCESS_LOG_FORMAT`: Message format for Gunicorn's access log. See [variable details](https://docs.gunicorn.org/en/stable/settings.html#access-log-format) to define your own format.
- `ACCESS_LOG_LOCATION`: The location to write access logs to. If set to `-`, the logs will be sent to `stdout`

## Platform Architectures

Our Docker images are built against the following CPU architectures:

- `amd64`
- `linux/arm64`
- `linux/arm/v7`

## Architecture

The docker-compose file runs the following containers:

### Frontend Dashboard and REST API Combined - Port 8000

The web user interface allows you to create accounts and manage your flags. The frontend is written in Node.js and React.

The web user interface communicates via REST to the API that powers the application. The SDK clients also connect to this API. The API is written in Django and the Django REST Framework.

Once you have created an account and some flags, you can then start using the API with one of the [Flagsmith Client SDKs](https://github.com/Flagsmith?q=client&type=&language=). You will need to override the API endpoint for each SDK to point to [http://localhost:8000/api/v1/](http://localhost:8000/api/v1/).

You can access the Django Admin console to get CRUD access to some of the core tables within the API. You will need to create a superuser account first with the following command:

```bash
# Make sure you are in the root directory of this repository
docker-compose run --rm --entrypoint "python manage.py createsuperuser" api
```

You can then access the admin dashboard at [http://localhost:8000/admin/](http://localhost:8000/admin/)

### PostgreSQL Database

The REST API stores all its data within a PostgreSQL database. Schema changes will be carried out automatically when upgrading using Django Migrations.

## Access Flagsmith Remotely

You will need to either open ports into your Docker host or set up a reverse proxy to access the two Flagsmith services (dashboard and API). You will also need to configure the dashboard environment variable `API_URL`, which tells the dashboard where the REST API is located.
