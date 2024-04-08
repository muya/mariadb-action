#!/bin/sh

docker_run="docker run"

if [ -n "$INPUT_DB_INIT_SCRIPT" ]; then
  echo "Setting db init script $PWD/$INPUT_DB_INIT_SCRIPT"

  docker_run="$docker_run -v $PWD/$INPUT_DB_INIT_SCRIPT"
fi

# if [ -n "$INPUT_MYSQL_ROOT_PASSWORD" ]; then
#   echo "Root password not empty, setting provided password for root user"

#   docker_run="$docker_run -e MYSQL_ROOT_PASSWORD=$INPUT_MYSQL_ROOT_PASSWORD"
# fi

# if [ -n "$INPUT_MYSQL_USER" ]; then
#   if [ -z "$INPUT_MYSQL_PASSWORD" ]; then
#     echo "The mysql password must not be empty when mysql user exists"
#     exit 1
#   fi

#   echo "Use specified user and password"

#   docker_run="$docker_run -e MYSQL_RANDOM_ROOT_PASSWORD=true -e MYSQL_USER=$INPUT_MYSQL_USER -e MYSQL_PASSWORD=$INPUT_MYSQL_PASSWORD"
# fi

# if [ -z "$INPUT_MYSQL_USER" ] && [ -z "$INPUT_MYSQL_ROOT_PASSWORD" ]; then
#   echo "neither root password nor mysql user provided. Allowing empty password for root"

#   docker_run="$docker_run -e MYSQL_ALLOW_EMPTY_PASSWORD=true"
# fi


if [ -n "$INPUT_MYSQL_ROOT_PASSWORD" ]; then
  echo "Root password not empty, use root superuser"

  docker_run="$docker_run -e MARIADB_ROOT_PASSWORD=$INPUT_MYSQL_ROOT_PASSWORD"
elif [ -n "$INPUT_MYSQL_USER" ]; then
  if [ -z "$INPUT_MYSQL_PASSWORD" ]; then
    echo "The mysql password must not be empty when mysql user exists"
    exit 1
  fi

  echo "Use specified user and password"

  docker_run="$docker_run -e MARIADB_RANDOM_ROOT_PASSWORD=true -e MARIADB_USER=$INPUT_MYSQL_USER -e MARIADB_PASSWORD=$INPUT_MYSQL_PASSWORD"
else
  echo "Using empty password for root"

  docker_run="$docker_run -e MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=true"
fi

if [ -n "$INPUT_MYSQL_DATABASE" ]; then
  echo "Use specified database"

  docker_run="$docker_run -e MARIADB_DATABASE=$INPUT_MYSQL_DATABASE"
fi

docker_run="$docker_run -d -p $INPUT_HOST_PORT:$INPUT_CONTAINER_PORT mariadb:$INPUT_MARIADB_VERSION --port=$INPUT_CONTAINER_PORT"
docker_run="$docker_run --character-set-server=$INPUT_CHARACTER_SET_SERVER --collation-server=$INPUT_COLLATION_SERVER"

echo "Full docker run command: [$docker_run]"

sh -c "$docker_run"
