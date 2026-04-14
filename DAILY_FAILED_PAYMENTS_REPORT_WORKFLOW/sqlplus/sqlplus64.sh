#!/bin/bash

source ~/.bash_aliases

# NOTE: I am using .bash_aliases to set the environment variables for both Oracle and MSS databases,
#       you can choose to set them in .bashrc or directly in this script as well.
set_cover_stg_env_vars

sqlplus64 -s $ORACLE_USERNAME/$ORACLE_PASSWORD@//$ORACLE_HOST:$ORACLE_PORT/$ORACLE_SID @query.sql > output.csv

# NOTE: I am using .bash_aliases to set the environment variables for both Oracle and MSS databases,
#       you can choose to set them in .bashrc or directly in this script as well.
unset_cover_stg_env_vars