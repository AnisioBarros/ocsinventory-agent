#!/bin/bash -x

DIR="/etc/ocsinventory/"
if [ -d "$DIR" ]; then
  echo "diretorio ${DIR} ja existe"
  sleep 0.5; echo -n " [ OK ]"; echo 
else
  echo "criando diretorio ${DIR}"
  mkdir -p /etc/ocsinventory/
  sleep 0.5; echo -n " [ OK ]"; echo 
fi

echo -n "Criando diretorios e dando permissoes... "
sleep 0.5; echo -n " [ OK ]"; echo 

FILE="/etc/ocsinventory/ocsinventory-agent.cfg"
if [ -f "$FILE" ]; then
    echo "arquivo ja existe, vou atualizar"
    sleep 0.5; echo -n " [ OK ]"; echo 
    touch ${FILE} ;
    chmod 0766 ${FILE} ;
        if [ $? -eq 0 ]
        then
        echo "arquivo criado com sucesso"
        sleep 0.5; echo -n " [ OK ]"; echo 
        else
        echo "nao foi possivel criar o arquivo"
        chattr -i ${FILE}
        touch ${FILE} ;
        chmod 0766 ${FILE} ;
        fi
    echo -n "Carregando informacoes do servidor ocs... "
    echo "server=http://ocs.dev.infra.mateus/ocsinventory" > ${FILE} ;
    sleep 2 ; 
else 
    echo "${FILE} nao existe, vou criar."
    touch ${FILE} ;
    chmod 0766 ${FILE} ;
        if [ $? -eq 0 ]
        then
        echo "arquivo criado com sucesso"
        sleep 0.5; echo -n " [ OK ]"; echo 
        else
        echo "nao foi possivel criar o arquivo"
        chattr -i ${FILE}
        fi    
    echo -n "Carregando informacoes do servidor ocs... "
    sleep 0.5; echo -n " [ OK ]"; echo 
    echo "server=http://ocs.dev.infra.mateus/ocsinventory" > ${FILE} ;
    sleep 2 ;     
fi
echo -n "Instalando agente do ocs... "
sleep 0.5; echo -n " [ OK ]"; echo 

  if ! apt update
  then
      printf "Não foi possível atualizar os repositórios. Verifique seu arquivo /etc/apt/sources.list"
      exit 1
  fi

  echo "Atualização de repositório feita com sucesso"

  if ! DEBIAN_FRONTEND=noninteractive apt install ocsinventory-agent -y
  then
      printf "Não foi possível instalar o pacote ocsinventory-agent"
      exit 1
  fi
  printf "Instalação do ocsinventory-agent finalizada"

sleep 0.5; echo -n " [ OK ]"; echo 

FILE="/etc/cron.daily/ocsinventory-agent"
echo -n "Agendando envio de dados de hora em hora... "
sleep 1.5; echo -n " [ OK ]"; echo 
if [ -f "$FILE" ]; then
    echo "arquivo ja existe, vou atualizar"
    sleep 0.5; echo -n " [ OK ]"; echo 
    cp ${FILE} /etc/cron.hourly/ocsinventory-agent
    sleep 2 ; 
    /etc/init.d/cron restart
    echo -n "Restart do cron... "
    bash /etc/cron.hourly/ocsinventory-agent
    sleep 1.5; echo -n " [ OK ]"; echo 
else 
    echo "arquivo nao existe, vou criar"
    cp /etc/cron.hourly/ocsinventory-agent ${FILE}
    sleep 2 ;  
    /etc/init.d/cron restart
    echo -n "Restart do cron... "
    bash /etc/cron.hourly/ocsinventory-agent
    sleep 1.5; echo -n " [ OK ]"; echo 
fi