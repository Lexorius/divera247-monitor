###  Einleitung

Das Projekt basiert auf den Scripten von  https://family-giese.de/Bewegungsmelder  - ist aber modifiziert. 
Leider ist die Firmware für die Bewegungsmelder Closed Sources und nur auf dem esp8266 verfügbar. Das macht kein Sinn. 

Ich hab mir das Angeschaut und umgebaut auf ein Connect mit Home Assistant. 

inklusive neuem Feature Dienste via Kalender von dem Homeassistant anzulegen. 

###  Installation : 

Die Grundinstallation des Raspberrys ist in diesem Fall Raspbian 12 mit Desktop.  (Via Raspberry Imager default installation)

Nach Namensänderung des Pi und Festlegung eines Logins 

  die Dateien divera_command.sh und divera_screen.sh in den ordner /usr/local/bin laden. 
  
  vorher noch notwendige tools installieren 

    sudo apt update     #erstmal nach updates suchen
    sudp apt upgrade -y # dann updates ausführen
    sudo apt install mosquitto-client  #mqtt client installieren 
    

  

