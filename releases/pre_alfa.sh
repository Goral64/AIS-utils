#!/data/data/pl.sviete.dom/files/usr/bin/bash
# AIS
# Homepage: https://ai-speaker.com
################################################
# Install ais-dom on PRE ALFA chanel
# run it by executiong in AIS dom console:
# curl -L https://raw.githubusercontent.com/sviete/AIS-utils/master/releases/pre_alfa.sh | bash
#

# AIS VERSIONS
AIS_VERSSION="21.11.10"
AIS_HA_VERSSION="2021.11.5b0"
AIS_ZIGBEE_VERSION='"version": "1.22.0",'
AIS_ANDROID_VERSSION="versionName=3.0.1"
AIS_VERSSION_OLD="210919"
# AIS VERSIONS

echo -e '\e[38;5;220m START instalacji wersji \e[30;48;5;208m AIS PRE ALFA ' "$AIS_VERSSION" '\e[0m'
curl http://localhost:8122/text_to_speech?text=Start%20instalacji%20wersji%AIS%20ALFA

# fix for not dispatching media key event because user setup is in progress
su -c 'settings put secure user_setup_complete 1'


apt update
curl -o ~/AIS/logo.txt -L https://raw.githubusercontent.com/sviete/AIS-utils/master/releases/logo.txt
apt install -y w3m
apt install -y neofetch
neofetch --source  ~/AIS/logo.txt

# TEST requirements
AIS_CURR_VERSION=`cat /data/data/pl.sviete.dom/files/home/AIS/.ais_apt`
echo -e '\e[38;5;220m Aktualizacja AIS z wersji ' "$AIS_CURR_VERSION" ' \e[0m'
AIS_CURR_VERSION="${AIS_CURR_VERSION//.}"

if [ $AIS_CURR_VERSION -ge $AIS_VERSSION_OLD ]
  then
    echo -e '\e[38;5;220m VERSION TEST \e[30;48;5;208m OK \e[0m'
  else
    curl http://localhost:8122/text_to_speech?text=Stop%20niezgodno%C5%9B%C4%87%20wersji
    curl -X POST http://localhost:8180/api/webhook/aisdomprocesscommandfromframe -H 'Content-Type: application/json' -d '{"topic":"ais/set_update_status", "payload": "outdated"}'
    echo -e '\e[38;5;220m Niezgodność wersji \e[30;48;5;208m EXIT\e[0m'
    echo -e '\e[38;5;220m VERSION NOK \e[30;48;5;208m STOP\e[0m'
    echo -e '\e[38;5;220m VERSION NOK \e[30;48;5;208m STOP\e[0m'
    echo -e '\e[38;5;220m VERSION NOK \e[30;48;5;208m STOP\e[0m'

    exit 1
fi



SECONDS=0
# AIS PYTHON APP
echo -e '\e[38;5;220m Pobieram AIS ... \e[0m'
curl http://localhost:8122/text_to_speech?text=Pobieram%20AIS
curl -X POST http://localhost:8180/api/webhook/aisdomprocesscommandfromframe -H 'Content-Type: application/json' -d '{"topic":"ais/set_update_status", "payload": "downloading"}'
curl -X POST http://localhost:8180/api/webhook/aisdomprocesscommandfromframe -H 'Content-Type: application/json' -d '{"topic":"ais/set_update_progress", "payload": "0.1:0.3"}'
curl -o "/data/data/pl.sviete.dom/files/home/AIS/pre_alfa_wheelhouse.tar.7z" -L  https://github.com/sviete/AIS-utils/blob/master/releases/pre_alfa_wheelhouse.tar.7z?raw=true
curl -X POST http://localhost:8180/api/webhook/aisdomprocesscommandfromframe -H 'Content-Type: application/json' -d '{"topic":"ais/set_update_progress", "payload": "0.2:0.6"}'

echo -e '\e[38;5;220m Rozpakowuje AIS ... \e[0m'
curl http://localhost:8122/text_to_speech?text=Rozpakowuje%20AIS
7z x -mmt=2 -o/data/data/pl.sviete.dom/files/home/AIS/ /data/data/pl.sviete.dom/files/home/AIS/pre_alfa_wheelhouse.tar.7z -y
curl -X POST http://localhost:8180/api/webhook/aisdomprocesscommandfromframe -H 'Content-Type: application/json' -d '{"topic":"ais/set_update_progress", "payload": "0.3:0.6"}'

echo -e '\e[38;5;220m Instaluje AIS ... \e[0m'
curl http://localhost:8122/text_to_speech?text=Instaluje%20AIS
curl -X POST http://localhost:8180/api/webhook/aisdomprocesscommandfromframe -H 'Content-Type: application/json' -d '{"topic":"ais/set_update_status", "payload": "installing"}'
cd /data/data/pl.sviete.dom/files/home/AIS
pip install -r wheels/requirements.txt --no-index --find-links wheels -U
curl -X POST http://localhost:8180/api/webhook/aisdomprocesscommandfromframe -H 'Content-Type: application/json' -d '{"topic":"ais/set_update_progress", "payload": "0.6:0.6"}'
rm -rf /data/data/pl.sviete.dom/files/home/AIS/wheels
rm -rf /data/data/pl.sviete.dom/files/home/AIS/pre_alfa_wheelhouse.tar.7z


# AIS ZIGBEE APP
echo -e '\e[38;5;220m ZIGBEE \e[30;48;5;208m ' "$AIS_ZIGBEE_VERSION" '\e[0m'
if  grep -q "$AIS_ZIGBEE_VERSION" '/data/data/pl.sviete.dom/files/home/zigbee2mqtt/package.json' ; then
  echo -e '\e[38;5;220m Zigbee OK... \e[0m'
else
  echo -e '\e[38;5;220m Pobieram Zigbee ... \e[0m'
  curl http://localhost:8122/text_to_speech?text=Pobieram%20Zigbee
  curl -H 'Cache-Control: no-cache' -o "/data/data/pl.sviete.dom/files/home/AIS/zigbee_update.zip" -L http://powiedz.co/ota/zigbee_alfa.zip
  curl -X POST http://localhost:8180/api/webhook/aisdomprocesscommandfromframe -H 'Content-Type: application/json' -d '{"topic":"ais/set_update_progress", "payload": "0.6:0.9"}'
  cp -R /data/data/pl.sviete.dom/files/home/zigbee2mqtt/data /data/data/pl.sviete.dom/files/home/data-backup
  rm -rf /data/data/pl.sviete.dom/files/home/zigbee2mqtt

  echo -e '\e[38;5;220m Rozpakowuje Zigbee ... \e[0m'
  curl http://localhost:8122/text_to_speech?text=Rozpakowuje%20Zigbee
  7z x -mmt=2 -o/data/data/pl.sviete.dom/files/home/zigbee2mqtt /data/data/pl.sviete.dom/files/home/AIS/zigbee_update.zip -y
  rm -rf /data/data/pl.sviete.dom/files/home/AIS/zigbee_update.zip
  cp -R /data/data/pl.sviete.dom/files/home/data-backup/* /data/data/pl.sviete.dom/files/home/zigbee2mqtt/data
  rm -rf /data/data/pl.sviete.dom/files/home/data-backup
fi
curl -X POST http://localhost:8180/api/webhook/aisdomprocesscommandfromframe -H 'Content-Type: application/json' -d '{"topic":"ais/set_update_progress", "payload": "0.9:0.92"}'


echo -e '\e[40;38;5;220m OK. Instalacja trwała \e[30;48;5;208m' "$SECONDS" 'sekund \e[0m'
curl http://localhost:8122/text_to_speech?text=Instalacja%20trwa%C5%82a%20$SECONDS%20sekund.%20Poczekaj%20na%20ponowne%20uruchomienie%20systemu.

echo "$AIS_VERSSION" > /data/data/pl.sviete.dom/files/home/AIS/.ais_apt

sleep 6

# AIS ANDROID APP
echo -e '\e[38;5;220m ANDROID \e[30;48;5;208m ' "$AIS_ANDROID_VERSSION" '\e[0m'
if [ `su -c "dumpsys package pl.sviete.dom | grep versionName" | tr -d '[:space:]'` != "$AIS_ANDROID_VERSSION" ]; then
    echo -e '\e[38;5;220m Pobieram i instaluje Android ... \e[0m'
    curl http://localhost:8122/text_to_speech?text=Pobieram%20Android%20i%20restartuje%20AIS
    curl -X POST http://localhost:8180/api/webhook/aisdomprocesscommandfromframe -H 'Content-Type: application/json' -d '{"topic":"ais/set_update_progress", "payload": "0.95:0.95"}'
    curl -X POST http://localhost:8180/api/webhook/aisdomprocesscommandfromframe -H 'Content-Type: application/json' -d '{"topic":"ais/set_update_status", "payload": "restart"}'
    su -c 'am start -n launcher.sviete.pl.domlauncherapp/.LauncherActivity -e command ais-dom-update-beta'
    curl -X POST http://localhost:8180/api/webhook/aisdomprocesscommandfromframe -H 'Content-Type: application/json' -d '{"topic":"ais/set_update_progress", "payload": "1:0.97"}'
else
    echo -e '\e[38;5;220m Android OK... \e[0m'
    echo -e '\e[38;5;220m Restartuje usługę ais ... \e[0m'
    curl http://localhost:8122/text_to_speech?text=Restartuje%20us%C5%82ug%C4%99%20AIS
    curl -X POST http://localhost:8180/api/webhook/aisdomprocesscommandfromframe -H 'Content-Type: application/json' -d '{"topic":"ais/set_update_status", "payload": "restart"}'
    curl -X POST http://localhost:8180/api/webhook/aisdomprocesscommandfromframe -H 'Content-Type: application/json' -d '{"topic":"ais/set_update_progress", "payload": "1:0.95"}'
    # restart ais
    pkill -9 python
fi

exit 0
