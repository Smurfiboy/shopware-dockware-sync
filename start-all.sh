FILENAME='nüscht'
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  DISTRIB=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
  if [[ ${DISTRIB} = "\"Ubuntu"\"* ]]; then
    if uname -a | grep -qi '^Linux.*Microsoft'; then
      SYSTEM="Windows WSL"
      FILENAME='docker-sync.windows.yml'
    else
      SYSTEM="Linux"
      FILENAME='docker-sync.windows.yml'
    fi
  elif [[ ${DISTRIB} = "\"Debian"\"* ]]; then
      SYSTEM="Linux"
      FILENAME='docker-sync.windows.yml'
  fi
elif [[ "$OSTYPE" == "\"darwin"\"* ]]; then
  if [[ $(uname -p) == 'arm' ]]; then
    FILENAME='docker-sync.mac.m1.yml' 
    SYSTEM='Mac M1'
  else
    FILENAME='docker-sync.mac.yml' 
    SYSTEM='Mac'
  fi
fi

case "$1" in
    start)
          echo "Starting docker-sync and docker-compose on $SYSTEM"
	  docker-sync start -c $FILENAME
	  docker-compose up -d
          echo "."
          ;;
      stop) 
          echo "Stopping docker-sync and docker-compose on $SYSTEM"
	  docker-compose down
          docker-sync stop -c $FILENAME
          echo "."
          ;;
   restart)
          echo "Restarting docker-sync"
 	  docker-sync restart -c $FILENAME
	  echo "."
  	  ;;
   	 *)
          echo "Usage: .\start-all.sh start|stop|restart"
          exit 1
          ;;
esac