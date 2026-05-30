#!/bin/bash

# Colores por plataforma
if [[ -n "$PREFIX" ]]; then
    # Termux
    RED='\033[1;31m'
    GREEN='\033[1;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[1;34m'
    NC='\033[0m'
else
    # Linux/Windows Git Bash
    RED='\e[1;31m'
    GREEN='\e[1;32m'
    YELLOW='\e[1;33m'
    BLUE='\e[1;34m'
    NC='\e[0m'
fi

banner() {
    clear
    echo -e "${RED}"
    echo "  __  __ _   _  ____                     "
    echo " |  \/  | | | |/ ___| __ _  __ _  ___ _ __ "
    echo " | |\/| | |_| | |  _ / _\` |/ _\` |/ _ \ '__|"
    echo " | |  | |  _  | |_| | (_| | (_| |  __/ |   "
    echo " |_|  |_|_| |_|\____|\__,_|\__, |\___|_|   "
    echo "                           |___/           "
    echo -e "${GREEN}     Multi-Platform Network Scanner${NC}"
    echo -e "${YELLOW}        by Falconmx1${NC}"
    echo "========================================="
}

menu() {
    echo -e "${BLUE}[1]${NC} Escaneo rápido de puertos"
    echo -e "${BLUE}[2]${NC} Escaneo completo de puertos (1-65535)"
    echo -e "${BLUE}[3]${NC} Escaneo de red local (hosts activos)"
    echo -e "${BLUE}[4]${NC} Detección de SO"
    echo -e "${BLUE}[5]${NC} Escaneo UDP"
    echo -e "${BLUE}[6]${NC} Exportar resultados a JSON"
    echo -e "${BLUE}[7]${NC} Salir"
    echo "========================================="
}

scan_ports() {
    read -p "Ingresa IP objetivo: " ip
    read -p "Puertos a escanear (ej: 22,80,443 o 1-1000): " ports
    echo -e "${GREEN}[+] Escaneando $ip en puertos $ports...${NC}"
    nmap -p $ports -sV $ip
    echo -e "${GREEN}[+] Escaneo completado.${NC}"
    read -p "¿Guardar resultados? (s/n): " save
    if [[ $save == "s" ]]; then
        nmap -p $ports -sV $ip -oN "scan_$(date +%Y%m%d_%H%M%S).txt"
        echo -e "${GREEN}Guardado como scan_$(date +%Y%m%d_%H%M%S).txt${NC}"
    fi
}

full_scan() {
    read -p "Ingresa IP objetivo: " ip
    echo -e "${YELLOW}[!] Escaneo completo. Puede tomar varios minutos...${NC}"
    nmap -p- -sV -O $ip
    read -p "¿Guardar resultados? (s/n): " save
    if [[ $save == "s" ]]; then
        nmap -p- -sV -O $ip -oN "full_scan_$(date +%Y%m%d_%H%M%S).txt"
    fi
}

network_scan() {
    read -p "Ingresa red (ej: 192.168.1.0/24): " network
    echo -e "${GREEN}[+] Escaneando hosts activos en $network...${NC}"
    nmap -sn $network
}

os_detection() {
    read -p "Ingresa IP objetivo: " ip
    echo -e "${GREEN}[+] Detectando SO...${NC}"
    nmap -O --osscan-guess $ip
}

udp_scan() {
    read -p "Ingresa IP objetivo: " ip
    echo -e "${YELLOW}[!] Escaneo UDP lento. Requiere permisos root.${NC}"
    nmap -sU --top-ports 100 $ip
}

export_json() {
    read -p "Ingresa IP objetivo: " ip
    read -p "Nombre del archivo de salida: " filename
    nmap -p- -sV $ip -oX "${filename}.xml"
    echo -e "${GREEN}[+] Exportado a ${filename}.xml (convertible a JSON)${NC}"
    echo -e "${YELLOW}Para convertir a JSON: pip install xmltodict && python -c 'import xmltodict,json; f=open(\"${filename}.xml\"); print(json.dumps(xmltodict.parse(f.read())))' > ${filename}.json${NC}"
}

banner
while true; do
    menu
    read -p "Elige una opción: " opt
    case $opt in
        1) scan_ports ;;
        2) full_scan ;;
        3) network_scan ;;
        4) os_detection ;;
        5) udp_scan ;;
        6) export_json ;;
        7) echo -e "${RED}Saliendo...${NC}"; exit 0 ;;
        *) echo -e "${RED}Opción inválida${NC}" ;;
    esac
    echo ""
    read -p "Presiona Enter para continuar..."
    banner
done
