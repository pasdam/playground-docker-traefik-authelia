# playground-docker-traefik-authelia

Playground to test Authelia inegration with Traefik in docker.

## Usage

First thing to do is to generate the required files, in particular the SSL
certificates and the Authelia user:

```shell
./init.sh
```

This will prompt you for the username (default to `user`) and password to use to
login.

Then you can spin up the services with:

```shell
docker compose up
```

This will start the required containers, in particular we have 3 services:

* [localhost](https://localhost): the Traefik dashboard, where you can see its
  configuration; this will be accessible without authentication; the request
  doesn't go through Authelia at all (the related middleware is not configured
  for this path);
* [whoami1](https://localhost/whoami1): service 1, it will print info about the
  requests; accessible without authentication, but the reqeusts are processed by
  Authelia;
* [whoami2](https://localhost/whoami2): service 2, it will print info about the
  requests; accessible with authentication.
