#!/bin/bash
# Exclude lightdm and xorg while protecting logs

checkMemes() {
    lst=('service' 'systemctl' 'initctl' 'tar' 'netstat' 'lsmod' 'apt-get' 'yum' 'date')
    for serv in "${lst[@]}"; do
        echo "Checking $serv...: $(command -v $serv)"
    done
    echo -n "Proceed? "
    read choice
    if [ "$choice" == "n" ]; then
        exit
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
        echo "Changing password for the following users:"
        echo `getActiveUsers`
        echo -n "n3w p4ssw0rd: "
        read newp4ss
        echo "root:$newp4ss" | chpasswd
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
    mkdir $BAKDIR
    # Backup logs
    tar -zc -f $BAKDIR/logs.tar.gz /var/log/
    # Backup configurations
    tar -zc -f $BAKDIR/configs.tar.gz /etc/
    # Backup binaries
    tar -zc -f $BAKDIR/bin.tar.gz `echo $PATH | awk -F: '{$1=$1} 1'` &
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
    elif [ -n "$(command -v initctl)" ]; then
        echo " === initctl === " >> crits.log
        initctl list >> crits.log
        echo " =============== " >> crits.log
    fi
    tar -zc -f $BAKDIR/crits.tar.gz /etc/sudoers /etc/passwd ./crits.log `find /home \( -name ".*_history" -o -name "*viminfo" \)`
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
    if [ -n "$(command -v service)" ]; then
        service cron stop
    elif [ -n "$(command -v systemctl)" ]; then
        systemctl stop cron
        systemctl disable cron
    elif [ -n "$(command -v initctl)" ]; then
        initctl stop cron
    fi
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
    chmod 440 /etc/sudoers
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
    find /var/log/* | grep -v "lightdm" | grep -v "Xorg.*.log*" | xargs -d'\n' -I {} chattr +a -R {}
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
    checkMemes 2>>checkMemes.error.log
    changePasswords 2>>changePasswords.error.log
    backupMemes 2>>backupMemes.error.log
    secureMemes 2>>secureMemes.error.log
    configMemes 2>>configMemes.error.log
    installMemes 2>>installMemes.error.log
    firewallUp 2>>firewallUp.error.log
}

main "$@"