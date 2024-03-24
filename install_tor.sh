#!/bin/bash

# Definição de variáveis globais
DirAtual="${PWD}"
TorConfigFile="/etc/tor/torrc"
ApacheService="apache2"
TorService="tor"
WebServerRoot="/var/www/html"
TorHiddenServiceDir="/var/lib/tor/web"

# Função de boas-vindas
mostrarBoasVindas() {
  clear
  echo "Seja bem-vindo ao ToolXMenu!"
  echo "Para mais informações, visite nossos perfis:"
  echo "- Linkedin: https://www.linkedin.com/in/thalles-canela/"
  echo "- YouTube: https://www.youtube.com/c/aXR6CyberSecurity"
  echo "- GitHub: https://github.com/ThallesCanela"
  echo "- GitHub: https://github.com/aXR6"
  echo "- Twitter: https://twitter.com/Axr6S"
  echo "Diretório atual: $DirAtual"
  echo "Lembre-se: Compartilhe conhecimento de forma ética!"
}

# Menu principal
toolxmenu() {
  PS3="Selecione uma opção: "
  options=("Preparar o sistema e configurar o TOR" "Sair")
  select opt in "${options[@]}"; do
    case $opt in
      "Preparar o sistema e configurar o TOR")
        instalarESetupTor
        ;;
      "Sair")
        break
        ;;
      *) echo "Opção inválida $REPLY";;
    esac
  done
}

# Instalação e configuração do Tor
instalarESetupTor() {
  echo "[✔] Preparando o ambiente..."
  sudo apt update
  sudo apt install apache2 tor -y

  echo "[✔] Iniciando o servidor web..."
  sudo systemctl enable $ApacheService
  sudo systemctl start $ApacheService

  echo "[✔] Configurando o Tor..."
  sudo bash -c "cat > $TorConfigFile <<EOF
SocksPort 9050
ControlPort 9051
HiddenServiceDir $TorHiddenServiceDir
HiddenServicePort 80 127.0.0.1:80
EOF"

  echo "[✔] Reiniciando o Tor..."
  sudo systemctl restart $TorService

  echo "[✔] Exibindo o endereço .onion..."
  sudo cat "$TorHiddenServiceDir/hostname"
}

# Função principal
main() {
  mostrarBoasVindas
  toolxmenu
}

main
