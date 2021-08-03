#!/bin/bash

FILEV=/home/steam/steamcmd/ark/ShooterGame/Binaries/Linux/start_server.sh
if [ -f "$FILEV" ]; then
    cp /home/steam/steamcmd/ark/ShooterGame/Binaries/Linux/start_server.sh /tmp/start_server.sh
    echo "LOG: Copied "
fi

echo "LOG: Copy Done"

cd /home/steam/steamcmd

echo "LOG: Start App_Update "

./steamcmd.sh +login anonymous +force_install_dir ark +app_update 376030 validate +quit

echo "LOG: App_Update Done"


FILET=/tmp/start_server.sh
if [ -f "$FILET" ]; then
    mv /tmp/start_server.sh /home/steam/steamcmd/ark/ShooterGame/Binaries/Linux/start_server.sh
    echo "LOG: Moved " $FILET
fi

echo "LOG: Move Done"

echo "Start Server"

cd /home/steam/steamcmd/ark/ShooterGame/Binaries/Linux/

./start_server.sh
