#!/bin/bash

getActiveUsers() {
    while IFS=: read a b dummy
    do
        if [ ! "$b" == "!" ] && [ ! "$b" == "*" ]; then
            echo "$a"
        fi
    done < /etc/shadow
}

changePasswords() {
    echo -n "n3w p4ssw0rd: "
    read newp4ss
    getActiveUsers | xargs -d'\n' -I {} sh -c "echo {}:$newp4ss | chpasswd"
}

changePasswords
