#!/bin/bash

set -e
set -x

DIR=$(cd "$(dirname "$0")"; pwd -P)

hugo

# directory to backup
SERVER_DIR="www/resources"

LOCAL_DIR="./public"

. "$DIR/env-creds.sh"

#yafc fish://"$SERVER_USER"@"$SERVER"

yafc  <<**
open fish://"$SERVER_USER":$SERVER_PASS@"$SERVER"
mkdir "$SERVER_DIR"
cd "$SERVER_DIR"
rm -rf *
put -rf $LOCAL_DIR/*
close
**
