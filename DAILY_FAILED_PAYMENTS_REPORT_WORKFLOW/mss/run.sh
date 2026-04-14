#!/bin/bash

# Test run.sh command:
# ./run.sh --restcall-url=https://yourdomain.com/yourendpoint --date-from=20251125 --date-to=20251127

# Parse arguments
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

# Validate required args
if [ -z "$RESTCALL_URL" ] || [ -z "$DATE_FROM" ] || [ -z "$DATE_TO" ]; then
  echo "Usage: ./run.sh --restcall-url=<url> --date-from=<YYYYMMDD> --date-to=<YYYYMMDD>"
  exit 1
fi

# Read query and substitute placeholders
QUERY=$(cat query.sql)
QUERY="${QUERY//:restcall_url/\'$RESTCALL_URL\'}"
QUERY="${QUERY//:date_from/\'$DATE_FROM\'}"
QUERY="${QUERY//:date_to/\'$DATE_TO\'}"

echo "Running query:"
echo -e "$QUERY\n"

source ~/.bash_aliases

set_mex_prod_env_vars

# Install pip if not already installed
# sudo apt install python3-pip

# Add a new venv for MSS DB
# python3 -m venv mssdb_env

# Install the pymssql package in the new venv
# pip install pymssql

# Create a new venv for MSS DB
# python -m venv mssdb_env

source mssdb_env/bin/activate

# Install the required packages in the new venv
# pip install -r requirements.txt

# Run the export.py script to execute the query and save results to output.csv
python3 export.py           \
 --user $MSS_USERNAME       \
 --password $MSS_PASSWORD   \
 --host $MSS_HOST           \
 --database $MSS_DATABASE   \
 --query "$QUERY"           \
 --output output.csv

# Run the format.py script to parse the database csv output and extract wanted values and format them as needed and save to output.txt
python format.py \
  --input output.csv \
  --outdir ../result \
  --outname output.txt

deactivate

unset_mex_prod_env_vars

# Copy the output.txt to n8n container
docker exec n8n mkdir -p /home/node/.n8n-files
docker cp ../result/output.txt n8n:/home/node/.n8n-files/

# Use Cluade to parse the database csv output and extract wanted values and format them as needed and save to output.txt
# claude --print --dangerously-skip-permissions "$(cat prompt.txt)"

echo $'\nDone! Formatted output.csv content and saved to output.txt'
