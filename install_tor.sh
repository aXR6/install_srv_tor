#!/bin/bash

DirAtual="${PWD}"

##toolxmenu##
##################
##START toolxmenu##
toolxmenu(){
   PS3="└──> ToolXMenu : "
   options=("Iniciar: Preparar o sistema, instalar componentes e configurar o TOR." "Mostrar o link ONION." "SAIR")
   select opt in "${options[@]}"
   do
      case $opt in
         "Iniciar: Preparar o sistema, instalar componentes e configurar o TOR.")
            INSTALLTOOLS
            GROUPADD
            USERCREAT
            PORTINFORM
            CREATFILE_multiuser
            STARTTOR
            ECHOLINK
            ;;
         "Mostrar o link ONION.")
            ECHOLINK
            ;;
         "SAIR")
            break
            ;;
         *) echo "A opção ($REPLY) não existe.";;
      esac
   done
}
##END toolxmenu##
################
##/toolxmenu##

INSTALLTOOLS()
{
echo -e "\033[1;31m[✔] Fazendo o UpDate - Sem instalar nada.\033[0m \033[1;31m \033[0m"
apt update

echo -e "\033[1;31m[✔] Instalando componentes.\033[0m \033[1;31m \033[0m"
apt install curl -y
apt install apt-transport-https -y

##echo -e "\033[1;32mAdicionando o repositorio do TOR.\033[0m \033[1;31m \033[0m"
##echo "deb https://deb.torproject.org/torproject.org stretch main" | sudo tee /etc/apt/sources.list.d/torproject.org.list > /dev/null
##curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import
##gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

##echo -e "\033[1;32mFazendo o UpDate - Sem instalar nada.\033[0m \033[1;31m \033[0m"
##apt update

echo -e "\033[1;31m[✔] Instalando o TOR.\033[0m \033[1;31m \033[0m"
#apt install tor deb.torproject.org-keyring tor-geoipdb torsocks -y
apt install tor -y

echo -e "\033[1;31m[✔] Instalando o Apache2.\033[0m \033[1;31m \033[0m"
apt install apache2 -y
}

GROUPADD()
{
echo -e "\033[1;31m[✔] Informe o nome do Groupo a ser criado: \033[0m \033[1;31m \033[0m"
read creatgroup
sudo groupadd $creatgroup
}

USERCREAT()
{
echo -e "\033[1;31m[✔] Informe o nome do Usuario a ser criado:  \033[0m \033[1;31m \033[0m"
read creatuser

echo -e "\033[1;31m[✔] Adicionando o usuario, inativando acesso, apontando a pasta. \033[0m \033[1;31m \033[0m"
sudo useradd -s /bin/false -g $creatgroup -d /var/www/html $creatuser

echo -e "\033[1;31m[✔] Adicionando permissões de acesso ao USUARIO ($creatuser) no GRUPO ($creatgroup). \033[0m \033[1;31m \033[0m"
sudo chown -R $creatgroup:$creatuser /var/www/html
sudo chmod -R 775 /var/www/html

echo -e "\033[1;31m[✔] Visualização: \033[0m \033[1;31m \033[0m"
ls -l /var/www/html
}

PORTINFORM()
{
echo -e "\033[1;31m[✔] Alterando o arquivo TORRC \033[0m \033[1;31m \033[0m"
echo -e "\033[1;31m[✔] Informe a PORTA (Ex.: 80 ou 443 ou etc...): \033[0m \033[1;31m \033[0m"
read informport

cat >'/etc/tor/torrc' <<EOT
HiddenServiceDir /var/lib/tor/hidden_service/
HiddenServicePort $informport 127.0.0.1:$informport
EOT

echo -e "\033[1;31m[✔] Movendo arquivo padrão \033[0m \033[1;31m \033[0m"
sudo mv /etc/init.d/tor ~/
}

CREATFILE_multiuser()
{
echo -e "\033[1;31m[✔] Criando arquivo de inicialização: \033[0m \033[1;31m \033[0m"
#cat >'/usr/lib/systemd/system/tor.service' <<EOT
cat >'/etc/systemd/system/tor.service' <<EOT
[Unit]
Description=Tor server
After=network.target

[Service]
Type=forking

RemainAfterExit=yes
ExecStart=/bin/true
ExecReload=/bin/true

User=$creatuser
Group=$creatgroup
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOT
echo -e "\033[1;31m[✔] Criado: OK. \033[0m \033[1;31m \033[0m"
}

STARTTOR()
{
echo -e "\033[1;32m[✔] Rodando o Serviço TOR: \033[0m \033[1;31m \033[0m"
sudo systemctl daemon-reload
ls /var/www/html
sudo systemctl start tor
sudo systemctl status tor
}

STARTTOR()
{
echo -e "\033[1;31m[✔] Criando index.html \033[0m \033[1;31m \033[0m"
cat >'/var/www/html/index.html' <<EOT
<!DOCTYPE html>
<html lang="pt-br">
  <head>
    <title>Toolx - ONION</title>
    <meta charset="utf-8">
  </head>
  <body>
    Sua primeira página. ONION!
  </body>
</html>
EOT
echo -e "\033[1;31m[✔] Criado: OK. \033[0m \033[1;31m \033[0m"
}

ECHOLINK()
{
echo -e "\033[1;31m[✔] Mostrando link ONION: \033[0m \033[1;31m \033[0m"
cat /var/lib/tor/hidden_service/hostname
}

##Bem Vindo##
#########################
##Inicio Bem Vindo##
clear && echo ""
echo "'########::'#######:::'#######::'##:::::::'##::::'##:::::::::::::::::::'###::::'##::::'##:'########:::'#######::"
echo "... ##..::'##.... ##:'##.... ##: ##:::::::. ##::'##:::::::::::::::::::'## ##:::. ##::'##:: ##.... ##:'##.... ##:"
echo "::: ##:::: ##:::: ##: ##:::: ##: ##::::::::. ##'##:::::::::::::::::::'##:. ##:::. ##'##::: ##:::: ##: ##::::..::"
echo "::: ##:::: ##:::: ##: ##:::: ##: ##:::::::::. ###:::::::'#######::::'##:::. ##:::. ###:::: ########:: ########::"
echo "::: ##:::: ##:::: ##: ##:::: ##: ##::::::::: ## ##::::::........:::: #########::: ## ##::: ##.. ##::: ##.... ##:"
echo "::: ##:::: ##:::: ##: ##:::: ##: ##:::::::: ##:. ##::::::::::::::::: ##.... ##:: ##:. ##:: ##::. ##:: ##:::: ##:"
echo "::: ##::::. #######::. #######:: ########: ##:::. ##:::::::::::::::: ##:::: ##: ##:::. ##: ##:::. ##:. #######::"
echo ":::..::::::.......::::.......:::........::..:::::..:::::::::::::::::..:::::..::..:::::..::..:::::..:::.......:::"
echo ""
echo -e "\033[1;32mSeja bem vindo ao ToolXMenu!\033[0m"
echo -e "\033[1;32mLinkedin:\033[0m https://www.linkedin.com/in/thalles-canela/"
echo -e "\033[1;32mYouTube: \033[0m https://www.youtube.com/c/aXR6CyberSecurity"
echo -e "\033[1;32mFacebook:\033[0m https://www.facebook.com/axr6PenTest"
echo -e "\033[1;32mGithub:  \033[0m https://github.com/ThallesCanela"
echo -e "\033[1;32mGithub:  \033[0m https://github.com/aXR6"
echo -e "\033[1;32mTwitter: \033[0m https://twitter.com/Axr6S"
echo -e "\033[1;32mPadim:   \033[0m https://www.padrim.com.br/aXR6CyberSecurity"
echo ""
echo -e "\033[1;32mDiretorio atual: $DirAtual\033[0m \033[1;31m \033[0m"
echo ""
echo -e "\033[1;31m:=> Não seja sujo! Se achou de graça, distribua de graça repassando os devidos créditos! \033[0m"
echo -e "\033[1;31m:=> Script ToolXMenu, desenvolvido por mim (Thalles Canela - ToolX), para organização das ferramentas encontradas em: \033[0m"
echo -e "\033[1;31m:=> https://github.com/aXR6 \033[0m"
echo ""
toolxmenu
##Fim Bem Vindo##
#######################
##/Bem Vindo##
