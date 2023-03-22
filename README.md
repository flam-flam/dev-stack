<img src="logos.svg" width=500>

Configs and setup for running the services locally.

## Docker compose

### Pre-requisites
docker version `>=23.0.0`

#### Steps:
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

3. Run the services in docker:
    ```bash
    make up
    ```
