<img src="logos.svg" width=500>

Configs and setup for running the services locally.

## Secrets

1. Create new or obtain existing Reddit credentials (required by the [dispatcher](https://github.com/flam-flam/dispatcher-service))
2. Create a `.env` file ([example](./example.env)):
    ```env
    REDDIT_CLIENT_ID=<value>
    REDDIT_CLIENT_SECRET=<value>
    MONGO_INITDB_ROOT_USERNAME=<value>
    MONGO_INITDB_ROOT_PASSWORD=<value>
    MONGO_CONNECTION_STRING=<value>
    DISPATCHER_BRANCH=main
    COMMENT_BRANCH=main
    SUBMISSION_BRANCH=main
    ```

## Docker compose

### Prerequisites

docker version `>=23.0.0`

#### Usage

Run the services in docker:
```bash
make docker-up
```

## Tilt

>Note that `Tiltfile` references the helm chart and the docker build path
>locally, so please make sure the repos below are pulled at the same level as this repo
>and are up to date:
> - `dispatcher-service`
> - `comment-service`
> - `submission-service` <-- _not yet, but soon_
> - `helm-charts`

### Prerequisites

[Tilt `>=v0.32.0`](https://docs.tilt.dev/install.html)

[KIND `>=v0.14.0`](https://kind.sigs.k8s.io/docs/user/quick-start/)

#### Usage

Run Tilt in a KIND cluster:
```bash
make tilt-up
```

This will start tilt in the foreground. Stopping it with Ctrl-c will stop
Tilt but won't delete the KIND cluster. Run `make tilt-down` to delete
cluster or just leave it to be reused next time to run `make tilt-up`.

You can of course still run any `tilt` commands (like `tilt up` or `tilt down`) in the `tilt/` folder.
