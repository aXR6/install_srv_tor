#!/bin/bash

DirAtual="${PWD}"

##toolxmenu##
##################
##START toolxmenu##
toolxmenu(){
   PS3="└──> ToolXMenu : "
   options=("Iniciar: Preparar o sistema, instalar componentes e configurar o TOR." "SAIR")
   select opt in "${options[@]}"
   do
      case $opt in
         "Iniciar: Preparar o sistema, instalar componentes e configurar o TOR.")
            INSTALLSRVTOR
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

INSTALLSRVTOR()
{
echo -e "\033[32;1m[✔] Preparando o ambiente \033[m"
apt install apache2 apache2-utils php php-cli php-mysql libapache2-mod-php php-gd php-xml php-curl php-common -y && 
systemctl enable apache2 && 
systemctl start apache2

echo -e "\033[32;1m[✔] Configuração das variáveis \033[m"
TOR_SOCKS_PORT=9050
TOR_CONTROL_PORT=9051
WEB_SERVER_PORT=80
WEB_SERVER_ROOT=/var/www/html

echo -e "\033[32;1m[✔] Inicia o servidor web \033[m"
sudo service apache2 start

echo -e "\033[32;1m[✔] Configura o Tor para usar o servidor web como ponto de entrada \033[m"
cat <<EOF | sudo tee /etc/tor/torrc
SocksPort $TOR_SOCKS_PORT
ControlPort $TOR_CONTROL_PORT
HiddenServiceDir /var/lib/tor/web
HiddenServicePort $WEB_SERVER_PORT 127.0.0.1:$WEB_SERVER_PORT
EOF

echo -e "\033[32;1m[✔] Reinicia o Tor para aplicar as alterações \033[m"
sudo service tor restart

echo -e "\033[32;1m[✔] Exibe o endereço .onion gerado pelo Tor \033[m"
echo -e "\033[32;1m[✔] Seu servidor está agora disponível na rede Tor em: \033[m"
sudo cat /var/lib/tor/web/hostname
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
