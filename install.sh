#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}[+] Iniciando instalación de Mx-Scanner...${NC}"

# Detectar plataforma
if [[ -n "$PREFIX" ]]; then
    echo -e "${GREEN}[+] Termux detectado${NC}"
    pkg update -y
    pkg install nmap -y
    pkg install curl -y
    pkg install git -y
    INSTALL_DIR="$PREFIX/bin"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo -e "${GREEN}[+] Linux detectado${NC}"
    sudo apt update
    sudo apt install nmap curl -y
    INSTALL_DIR="/usr/local/bin"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    echo -e "${GREEN}[+] Windows (Git Bash) detectado${NC}"
    echo -e "${RED}[!] Asegúrate de tener Nmap instalado manualmente desde https://nmap.org/download.html${NC}"
    INSTALL_DIR="/usr/bin"
else
    echo -e "${RED}[!] Plataforma no soportada${NC}"
    exit 1
fi

# Copiar script
cp mx-scanner.sh "$INSTALL_DIR/mx-scanner"
chmod +x "$INSTALL_DIR/mx-scanner"

echo -e "${GREEN}[+] Instalación completada. Ejecuta 'mx-scanner' desde cualquier terminal.${NC}"
