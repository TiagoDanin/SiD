#!/bin/sh
if [ "$1" = "install" ]; then
	echo "▀█▀ ▒█▄░▒█ ▒█▀▀▀█ ▀▀█▀▀ ░█▀▀█ ▒█░░░ ▒█░░░"
	echo "▒█░ ▒█▒█▒█ ░▀▀▀▄▄ ░▒█░░ ▒█▄▄█ ▒█░░░ ▒█░░░" 
	echo "▄█▄ ▒█░░▀█ ▒█▄▄▄█ ░▒█░░ ▒█░▒█ ▒█▄▄█ ▒█▄▄█"
	echo 'Install Lua (5.2)'
	sudo apt-get install lua5.2
	echo
	echo
	echo Pre-install
	echo redis-lua Copyright 2009-2012 Daniele Alessandri
	echo dkjson Copyright 2010-2014 David Heiko Kolf
	echo 
	echo Install Libs
	sudo apt-get install git make unzip lua-socket lua-sec redis-server
	mv key.lua.CONFIGME key.lua
	echo
	echo
	echo install TG-CLI and Lua-TG
	sudo apt-get install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev libevent-dev libjansson-dev libpython-dev make
	git clone http://github.com/topkecleon/lua-tg
	git clone http://github.com/vysheng/tg --recursive -b test
	cd tg
	./configure
	make
	echo
	echo
	cd ..
	./launch.sh license
elif [ "$1" = "license" ]; then
	echo "　 ▒█▀▀█ ▒█▀▀█ ▒█░░░ ▀█░█▀ █▀█" 
	echo "　 ▒█░▄▄ ▒█▄▄█ ▒█░░░ ░█▄█░ ░▄▀" 
	echo "　 ▒█▄▄█ ▒█░░░ ▒█▄▄█ ░░▀░░ █▄▄"
	echo "Base Otouto"
	echo "SiDbot By Tiago"
	echo "licensed GPLv2."
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