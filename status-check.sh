#!/bin/bash

# script using aws cli for to check for stack status and wait until process ends to continue

if aws cloudformation describe-stacks --stack-name="${STACK}"; then
    # stack doesn't exist so line won't trigger
    # if aws cloudformation describe-stacks --stack-name="${STACK}" | grep CREATE_IN_PROGRESS; then
    #     aws cloudformation wait stack-create-complete --stack-name="${STACK}"
    if aws cloudformation describe-stacks --stack-name="${STACK}" | grep UPDATE_IN_PROGRESS; then
        aws cloudformation wait stack-update-complete --stack-name="${STACK}"
    elif aws cloudformation describe-stacks --stack-name="${STACK}" | grep UPDATE_ROLLBACK_IN_PROGRESS; then
        aws cloudformation wait stack-rollback-complete --stack-name="${STACK}"
    elif aws cloudformation describe-stacks --stack-name="${STACK}" | grep DELETE_IN_PROGRESS; then
        aws cloudformation wait stack-delete-complete --stack-name="${STACK}"
    else
        echo "No stack activity in progress!  You are clear to compose up"
    fi
else
    echo "Stack does not exist yet"
fi