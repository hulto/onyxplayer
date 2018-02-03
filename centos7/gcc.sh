#!/bin/bash

checkMemes() {
    lst=('systemctl' 'tar' 'netstat' 'lsmod' 'apt-get' 'yum' 'date')
    for serv in "${lst[@]}"; do
        echo "Checking $serv...: $(command -v $serv)"
    done
    echo -n "Proceed? "
    read choice
    if [ "$choide" == "n" ]; then
        exit
    fi

    if [ -z "$(command -v systemctl)" ]; then
        echo -n "WARNING: NO SYSTEMCTL. PROCEED? "
        read choice
        if [ "$choice" == "n" ]; then
            exit
        fi
    fi
}

getActiveUsers() {
    while IFS=: read a b dummy
    do
        if [ ! "$b" == "!" ] && [ ! "$b" == "*" ]; then
            echo "$a"
        fi
    done < /etc/shadow
}

changePasswords() {
    echo -n "Change password? "
    read choice
    if [ $choice == "y" ]; then
        echo -n "n3w p4ssw0rd: "
        read newp4ss
        getActiveUsers | xargs -d'\n' -I {} sh -c "echo {}:$newp4ss | chpasswd"
    fi
    echo "Change password: Done."
    echo ""
}

backupMemes() {
    echo "Backing up all the memes"
    if [ ! -e /usr/arm-linux-gnu ]; then
        mkdir /usr/arm-linux-gnu/
    fi
    BAKDIR=/usr/arm-linux-gnu/$(date +%F-%T)
    # Backup logs
    tar -zcv -f $BAKDIR/logs.tar.gz /var/log/
    # Backup configurations
    tar -zcv -f $BAKDIR/configs.tar.gz /etc/
    # Backup binaries
    tar -zcv -f $BAKDIR/bin.tar.gz `echo $PATH | awk -F: '{$1=$1} 1'` &
    # Backup critial files and command output: .viminfo, .*_history
    echo " === netstat === " > crits.log
    netstat -tunalp >> crits.log
    echo " =============== " >> crits.log

    echo " === ps aux === " >> crits.log
    ps aux >> crits.log
    echo " =============== " >> crits.log

    echo " === lsmod === " >> crits.log
    lsmod >> crits.log
    echo " =============== " >> crits.log

    if [ -n "$(command -v systemctl)" ]; then
        echo " === systemctl === " >> crits.log
        systemctl >> crits.log
        systemctl list-unit-files >> crits.log
        echo " =============== " >> crits.log
    fi
    tar -zcv -f $BAKDIR/crits.tar.gz /etc/sudoers /etc/passwd ./crits.log `find /home \( -name ".*_history" -o -name "*viminfo" \)`
    rm ./crits.log
    echo "Done."
    echo ""
}

configMemes() {
    echo "configuring all the memes"

    # config SSH
    configSSH
    configSudoers
    echo "Done."
    echo ""
}

disableNotMeme() {
    # Disable cron
    echo "Disabling cron"
    systemctl stop cron
    systemctl disable cron

    mv ``
}

configSSH() {
    echo "configuring SSH"
    mv /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
    cp ./sshd_config /etc/ssh/
}

configSudoers() {
    echo "configuring sudoers"
    mv /etc/sudoers /etc/sudoers.bak
    cp ./sudoers /etc/
}

secureMemes() {
    echo "securing all the memes"
    secureLogs
    disableNotMeme
    echo "Done."
    echo ""
}

secureLogs() {
    echo "securing logs"
    chattr +a -R /var/log/*
}

installMemes() {
    if [ -n "$(command -v yum)" ]; then
        # yum -y update
        echo "yum: YES"
    elif [ -n "$(command -v apt-get)" ]; then
        # apt-get -y update
        echo "apt-get: YES"
    fi
    echo "Done."
    echo ""
}

firewallUp() {
    echo "Now, bow to my firewall"
    sh -c ./tables.sh
    echo "Done."
    echo ""
}

main() {
    checkMemes
    changePasswords
    backupMemes
    secureMemes
    configMemes
    installMemes
    firewallUp
}

main "$@"