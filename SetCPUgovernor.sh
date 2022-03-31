#!/bin/bash
# Battery charge limiter for Asus laptops
# By Rudra Pratap Singh
# License: GNU GPLv3

### FUNCTIONS ###

WelcomeMessage()
{

	kdialog --title "Welcome" --msgbox "This Script will set the CPU Governor for the system.\n Please make sure that the system is up to date." &>/dev/null

}


error() { printf "%s\n" "$1"; exit ; }

getpassword()
{
	pass1=1
	pass2=2
	while ! [ "$pass1" = "$pass2" ]; do
	pass1=$(kdialog  --password "Enter Sudoer's Password." 2>/dev/null)
	pass2=$(kdialog  --password "Retype Password Password." 2>/dev/null)
	done ;
}

SetLimit()
{
touch temp
cat  > temp << EOF
[Unit]
Description=CPU powersave
[Service]
Type=oneshot
ExecStart=/usr/bin/cpupower -c all frequency-set -g powersave
[Install]
WantedBy=multi-user.target
EOF

	echo $pass1 | sudo -S cp temp /etc/systemd/system/cpupower.service
	echo $pass1 | sudo -S systemctl enable cpupower.service
	echo $pass1 | sudo -S systemctl start  cpupower.service
rm temp
}

completed()
{
	kdialog --title "Done" --msgbox "CPU Governor has been set" &>/dev/null
}

### ACTUAL SCRIPT ###

WelcomeMessage || error "User Exited at WelcomeMessage"
getpassword || error "User Exited at setpassword"
SetLimit || error "User Exited at SetLimit"
completed || error "User Exited at completed"
