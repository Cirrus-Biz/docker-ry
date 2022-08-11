#!/bin/bash

# script using aws cli for to check for stack status and wait until process ends to continue

if aws cloudformation describe-stacks --stack-name="ac-ecs"; then
    if aws cloudformation describe-stacks --stack-name="ac-ecs" | grep CREATE_IN_PROGRESS; then
        aws cloudformation wait stack-create-complete --stack-name="ac-ecs"
    elif aws cloudformation describe-stacks --stack-name="ac-ecs" | grep UPDATE_IN_PROGRESS; then
        aws cloudformation wait stack-update-complete --stack-name="ac-ecs"
    elif aws cloudformation describe-stacks --stack-name="ac-ecs" | grep UPDATE_ROLLBACK_IN_PROGRESS; then
        aws cloudformation wait stack-rollback-complete --stack-name="ac-ecs"
    elif aws cloudformation describe-stacks --stack-name="ac-ecs" | grep DELETE_IN_PROGRESS; then
        aws cloudformation wait stack-delete-complete --stack-name="ac-ecs"
    else
        echo "No stack activity in progress!  You are clear to compose up"
    fi
else
    echo "Stack does not exist yet"
fi