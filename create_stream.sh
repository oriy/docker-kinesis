#!/usr/bin/env bash

aws --region $AWS_DEFAULT_REGION --endpoint-url https://localhost/ --no-verify-ssl kinesis create-stream --stream-name $@ --shard-count 1
