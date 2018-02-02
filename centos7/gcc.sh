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

backupMemes() {
    echo "backing up all the memes"
    # Backup logs

    # Backup configurations
    # Backup binaries
    # Backup critial files and command output
}

configMemes() {
    echo "configuring all the memes"

    # config SSH
    configSSH
}

configSSH() {
    echo "configuring SSH"
}

secureMemes() {
    echo "securing all the memes"
    secureLogs
}

secureLogs() {
    echo "securing logs"
    chattr +a -R /var/log/*
}

installMemes() {
    if [ -n "$(command -v yum)" ]; then
        # yum -y update
        echo "yes"
    elif [ -n "$(command -v apt-get)" ]; then
        # apt-get -y update
        echo "yes"
    fi
}

firewallUp() {
    echo "Now, bow to my firewall"
    sh -c ./tables.sh
}

main() {
    changePasswords
    backupMemes
    secureMemes
    configMemes
    installMemes
    firewallUp
}

main "$@"
