#!/bin/sh

if [[ ! -x "$(command -v docker)" ]]; then
  echo "You must install Docker on your machine";
  exit 1
fi

SCRIPT_DIR="$(cd "$( dirname "$0" )" >/dev/null && pwd )"
IMAGE=authelia/authelia:4.35.6

echo "Generating SSL certificate"
CERT_DIR=$SCRIPT_DIR/ingress/traefik/certs
mkdir -p $CERT_DIR
docker run --rm -a stdout -v $CERT_DIR:/tmp/certs $IMAGE authelia certificates generate --host test01234.hopto.org --dir /tmp/certs/ > /dev/null

read -ep "Enter your username for Authelia [user]: " USERNAME
if [ -z "$USERNAME" ]; then
  USERNAME="user"
fi

read -esp "Enter a password for '$USERNAME': " PASSWORD
PASSWORD=$(docker run --rm $IMAGE authelia hash-password $PASSWORD | sed 's/Password hash: //g')

cat <<EOT > $SCRIPT_DIR/sso/authelia/users_database.yml
---
# List of users
users:
   ${USERNAME}:
    displayname: ${USERNAME}'s name
    password: ${PASSWORD}
    email: ${USERNAME}@localhost
    groups:
      - admins
      - dev
...
EOT
