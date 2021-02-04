#!/bin/bash -x

DIR="/etc/ocsinventory/"
if [ -d "$DIR" ]; then
  echo "diretorio ${DIR} ja existe"
else
  echo "criando diretorio ${DIR}"
  mkdir -p /etc/ocsinventory/
  # exit 1
fi

echo -n "Criando diretorios e dando permissoes... "

FILE="/etc/ocsinventory/ocsinventory-agent.cfg"
if [ -f "$FILE" ]; then
    echo "arquivo ja existe, vou atualizar"
    touch ${FILE} ;
    chmod 0766 ${FILE} ;
        if [ $? -eq 0 ]
        then
        echo "arquivo criado com sucesso"
        else
        echo "nao foi possivel criar o importa.sh"
        chattr -i ${FILE}
        touch ${FILE} ;
        chmod 0766 ${FILE} ;
        fi
    sleep 0.5; echo -n " [ OK ]"; echo 
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
        else
        echo "nao foi possivel criar o arquivo"
        chattr -i ${FILE}
        fi    
    sleep 0.5; echo -n " [ OK ]"; echo 
    echo -n "Carregando informacoes do servidor ocs... "        
    echo "server=http://ocs.dev.infra.mateus/ocsinventory" > ${FILE} ;
    sleep 2 ;     
fi
sleep 0.5; echo -n " [ OK ]"; echo 
echo -n "Instalando agente do ocs... "
apt update -y ; 
DEBIAN_FRONTEND=noninteractive apt install -y ocsinventory-agent
FILE="/etc/cron.daily/ocsinventory-agent"
echo -n "Agendando envio de dados de hora em hora... "
sleep 1.5; echo -n " [ OK ]"; echo 
if [ -f "$FILE" ]; then
    echo "arquivo ja existe, vou atualizar"
    cp ${FILE} /etc/cron.hourly/ocsinventory-agent
    # chown bin:bin /etc/cron.hourly/ocsinventory-agent
    # chmod 0766 /etc/cron.hourly/ocsinventory-agent
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