#!/bin/bash

# Test run.sh command:
# ./run.sh --restcall-url=https://yourdomain.com/yourendpoint --date-from=20241125 --date-to=20261127

# parse arguments
for arg in "$@"; do
  case $arg in
    --restcall-url=*)
      RESTCALL_URL="${arg#*=}"
      ;;
    --date-from=*)
      DATE_FROM="${arg#*=}"
      ;;
    --date-to=*)
      DATE_TO="${arg#*=}"
      ;;
    *)
      echo "Unknown argument: $arg"
      exit 1
      ;;
  esac
done

# validate required args
if [ -z "$RESTCALL_URL" ] || [ -z "$DATE_FROM" ] || [ -z "$DATE_TO" ]; then
  echo "Usage: ./run.sh --restcall-url=<url> --date-from=<YYYYMMDD> --date-to=<YYYYMMDD>"
  exit 1
fi

# read query and substitute placeholders
QUERY=$(cat query.sql)
QUERY="${QUERY//:restcall_url/\'$RESTCALL_URL\'}"
QUERY="${QUERY//:date_from/\'$DATE_FROM\'}"
QUERY="${QUERY//:date_to/\'$DATE_TO\'}"

echo "Running query:"
echo "$QUERY"

source ~/.bash_aliases

# NOTE: I am using .bash_aliases to set the environment variables for both Oracle and MSS databases,
#       you can choose to set them in .bashrc or directly in this script as well.
set_mex_prod_env_vars

# Install pip if not already installed
# sudo apt install python3-pip

# Add a new venv for Oracle DB
# python3 -m venv oracledb_env

source ./oracledb_env/bin/activate

# Install the oracledb package in the new venv
# pip install oracledb

# Install the required packages in the new venv
# pip install -r requirements.txt

python3.12 export.py  \
 --user $ORACLE_USERNAME   \
 --password $ORACLE_PASSWORD   \
 --dsn $ORACLE_HOST:$ORACLE_PORT/$ORACLE_SID   \
 --query "$QUERY"   \
 --output output.csv

deactivate

# NOTE: I am using .bash_aliases to set the environment variables for both Oracle and MSS databases,
#       you can choose to set them in .bashrc or directly in this script as well.
unset_mex_prod_env_vars