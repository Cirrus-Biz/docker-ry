#!/bin/sh

# script using aws cli for to check for stack status and wait until process ends to continue
aws cloudformation describe-stacks --stack-name=${STACK} | $?

if [ $? -ne 0 ]; then
    echo "Stack ${STACK} does not yet exist"
else
    # Status check vars
    STATUS="`grep -m 1 "StackStatus" stack.txt`"
    CREATE="CREATE_IN_PROGRESS"
    UPDATE="UPDATE_IN_PROGRESS"
    ROLLBACK="UPDATE_ROLLBACK_IN_PROGRESS"
    DELETE="DELETE_IN_PROGRESS"

    if echo ${STATUS} | grep ${CREATE};then
        aws cloudformation wait stack-create-complete --stack-name=${STACK}
    elif echo ${STATUS} | grep ${UPDATE};then
        aws cloudformation wait stack-update-complete --stack-name=${STACK}
    elif echo ${STATUS} | grep ${ROLLBACK};then
        aws cloudformation wait stack-rollback-complete --stack-name=${STACK}
    elif echo ${STATUS} | grep ${DELETE};then
        aws cloudformation wait stack-delete-complete --stack-name=${STACK}
    else
        echo "No stack activity in progress!  You are clear to compose up"
    fi
fi

# debug comment