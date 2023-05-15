# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")

mkdir -p /var/ts3server
mkdir -p /var/ts3db
docker compose -f $SCRIPTPATH/../src/docker-compose.yml -p ts-server up --detach