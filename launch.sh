#!/bin/sh
if [ "$1" = "install" ]; then
	echo "▀█▀ ▒█▄░▒█ ▒█▀▀▀█ ▀▀█▀▀ ░█▀▀█ ▒█░░░ ▒█░░░"
	echo "▒█░ ▒█▒█▒█ ░▀▀▀▄▄ ░▒█░░ ▒█▄▄█ ▒█░░░ ▒█░░░"
	echo "▄█▄ ▒█░░▀█ ▒█▄▄▄█ ░▒█░░ ▒█░▒█ ▒█▄▄█ ▒█▄▄█"
	echo 'Install Lua (5.2)'
	sudo apt-get install lua5.2
	echo
	echo Install Libs
	sudo apt-get install git make unzip lua-socket lua-sec redis-server
	echo
	echo
	./launch.sh license
elif [ "$1" = "license" ]; then
	echo "　 ▒█▀▀█ ▒█▀▀█ ▒█░░░ ▀█░█▀ █▀█"
	echo "　 ▒█░▄▄ ▒█▄▄█ ▒█░░░ ░█▄█░ ░▄▀"
	echo "　 ▒█▄▄█ ▒█░░░ ▒█▄▄█ ░░▀░░ █▄▄"
	echo "Base on Otouto by Topkecleon"
	echo "SiDbot By TiagoDanin"
	echo "licensed AGPLv3."
	echo
	echo
	cat LICENSE
elif [ "$1" = "redis" ]; then
	sudo service redis-server start
	./launch.sh
else
	while true; do
		lua bot.lua
		sleep 5s
	done
fi
