#!/bin/bash -x
echo -n "Criando diretorios e dando permissoes... "
mkdir -p /etc/ocsinventory/
touch /etc/ocsinventory/ocsinventory-agent.cfg
chmod 0766 /etc/ocsinventory/ocsinventory-agent.cfg
sleep 0.5; echo -n " [ OK ]"; echo 
echo -n "Carregando informacoes do servidor ocs... "
echo "server=http://ocs.dev.infra.mateus/ocsinventory" > /etc/ocsinventory/ocsinventory-agent.cfg
sleep 0.5; echo -n " [ OK ]"; echo 
echo -n "Instalando agente do ocs... "
apt update -y ; 
DEBIAN_FRONTEND=noninteractive apt install -y ocsinventory-agent
cp /etc/cron.daily/ocsinventory-agent /etc/cron.hourly/ocsinventory-agent
echo -n "Agendando envio de dados de hora em hora... "
sleep 1.5; echo -n " [ OK ]"; echo 
chown bin:bin /etc/cron.hourly/ocsinventory-agent
chmod 0766 /etc/cron.hourly/ocsinventory-agent
/etc/init.d/cron restart
echo -n "Restart do cron... "
bash /etc/cron.hourly/ocsinventory-agent
sleep 1.5; echo -n " [ OK ]"; echo 
