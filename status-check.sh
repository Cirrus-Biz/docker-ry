#!/bin/sh

aws cloudformation describe-stacks --stack-name=${STACK} > stack.txt 2>&1

if [ $? -ne 0 ]; then
    echo "Stack ${STACK} does not yet exist"
else
    NUM="`grep -m 1 "StackStatus" stack.txt`"
    CREATE="CREATE_IN_PROGRESS"
    UPDATE="UPDATE_IN_PROGRESS"
    ROLLBACK="UPDATE_ROLLBACK_IN_PROGRESS"
    DELETE="DELETE_IN_PROGRESS"

    if echo ${NUM} | grep ${CREATE};then
        aws cloudformation wait stack-create-complete --stack-name=${STACK}
    elif echo ${NUM} | grep ${UPDATE};then
        aws cloudformation wait stack-update-complete --stack-name=${STACK}
    elif echo ${NUM} | grep ${ROLLBACK};then
        aws cloudformation wait stack-rollback-complete --stack-name=${STACK}
    elif echo ${NUM} | grep ${DELETE};then
        aws cloudformation wait stack-delete-complete --stack-name=${STACK}
    else
        echo "No stack activity in progress!  You are clear to compose up"
    fi
fi