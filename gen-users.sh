#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <number_of_users>"
    exit 1
fi

N=$1
OUT="users.txt"
PASSLEN=8

> $OUT

for i in $(seq 1 $N); do
    USERNAME="user$i"
    PASSWORD=$(openssl rand -base64 $PASSLEN | tr -dc 'a-zA-Z0-9' | head -c $PASSLEN)
    echo "$USERNAME:$PASSWORD" >> $OUT
done
