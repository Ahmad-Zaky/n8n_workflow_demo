#!/bin/bash

source ~/.bash_aliases

set_cover_stg_env_vars

sqlplus64 -s $ORACLE_USERNAME/$ORACLE_PASSWORD@//$ORACLE_HOST:$ORACLE_PORT/$ORACLE_SID @query.sql > output.csv

unset_cover_stg_env_vars