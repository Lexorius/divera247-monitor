###  Einleitung

Das Projekt basiert auf den Scripten von  https://family-giese.de/Bewegungsmelder  - ist aber modifiziert. 
Leider ist die Firmware für die Bewegungsmelder Closed Sources und nur auf dem esp8266 verfügbar. Somit ist es für mich unbrauchbar.
Wenn Du es einfach willst, nimm die Divera Monitor APP und die Anleitung von der Divera Homepage. Das hier ist ein bisschen Fortgetrittener. 

Wir haben beispielsweise ein "alten" TV der sich nicht gut Fernsteuern lässt und ein Homeassistent der die Bewegungssteuerung übernimmt und den TV via Kalender steuert. 

###  Installation : 

Die Grundinstallation des Raspberrys ist in diesem Fall Raspbian 12 mit Desktop.  (Via Raspberry Imager default installation)

Nach Namensänderung des Pi und Festlegung eines Logins 

  die Dateien divera_command.sh und divera_screen.sh in den ordner /usr/local/bin laden. 
  
  vorher noch notwendige tools installieren 

    sudo apt update     #erstmal nach updates suchen
    sudo apt upgrade -y # dann updates ausführen
    sudo apt install mosquitto-client unclutter #mqtt client  und unclutter installieren 
  
  Scripte holen und installation : 
  
    cd ~ 
    git clone https://github.com/Lexorius/divera247-monitor.git
    cd divera247-monitor
    sudo cp divera*.sh /usr/local/bin
    sudo chmod +x /usr/local/bin/divera*.sh 
    sudo echo "source /usr/local/bin/divera_command.sh" >> /etc/bash.bashrc 
    sudo mkdir -r ~/.config/autostart/
    sudo echo "[Desktop Entry]" > ~/.config/autostart/divera.desktop
    sudo echo "Version=1.0" >> ~/.config/autostart/divera.desktop
    sudo echo "Exec=/usr/local/bin/divera-monitor-runner.sh" >> ~/.config/autostart/divera.desktop
    sudo echo "Name=Divera Kiosk" >> ~/.config/autostart/divera.desktop
    sudo chmod 644 ~/.config/autostart/divera.desktop
    sudo reboot
    
# Home assistant :

da der Monitor via Home assistent geschaltet werden kann ist erstmal ein Kalender angelegt worden in dem die Dienste vermerkt sind. Das sind einfache Termine.

https://github.com/Lexorius/divera247-monitor/blob/main/examplepic/Event-1.png

Die Schaltung erfolgt via Automatismus-Logic in HA - Wenn ein Termin beginnt (oder hier eine Stunde bevor der Termin beginnt)
https://github.com/Lexorius/divera247-monitor/blob/main/examplepic/Automatismus_event_start.png
setzte in MQTT die topic tv/duty auf true
https://github.com/Lexorius/divera247-monitor/blob/main/examplepic/Automatismus_event_start.png





