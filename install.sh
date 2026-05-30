#!/bin/bash

# ==============================================
# Mx-Scanner v2.0 - Instalador Multi-Platform
# ==============================================

# Colores para output
if [[ -n "$PREFIX" ]]; then
    RED='\033[1;31m'
    GREEN='\033[1;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[1;34m'
    CYAN='\033[1;36m'
    NC='\033[0m'
else
    RED='\e[1;31m'
    GREEN='\e[1;32m'
    YELLOW='\e[1;33m'
    BLUE='\e[1;34m'
    CYAN='\e[1;36m'
    NC='\e[0m'
fi

# Banner de instalación
clear
echo -e "${CYAN}"
echo "  ╔════════════════════════════════════════╗"
echo "  ║     Mx-Scanner Installer v2.0          ║"
echo "  ║     Multi-Platform Network Scanner     ║"
echo "  ║          by Falconmx1                  ║"
echo "  ╚════════════════════════════════════════╝"
echo -e "${NC}"

# Detectar plataforma
detect_platform() {
    echo -e "${BLUE}[*] Detectando sistema operativo...${NC}"
    
    if [[ -n "$PREFIX" ]] && [[ -d "$PREFIX" ]]; then
        PLATFORM="termux"
        echo -e "${GREEN}[✓] Termux detectado${NC}"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        PLATFORM="linux"
        echo -e "${GREEN}[✓] Linux detectado${NC}"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
        PLATFORM="windows"
        echo -e "${YELLOW}[!] Windows (Git Bash/Cygwin) detectado${NC}"
    else
        PLATFORM="unknown"
        echo -e "${RED}[✗] Plataforma no soportada: $OSTYPE${NC}"
        exit 1
    fi
}

# Verificar root/sudo (solo para Linux)
check_privileges() {
    if [[ "$PLATFORM" == "linux" ]]; then
        if [[ $EUID -ne 0 ]]; then
            echo -e "${YELLOW}[!] Algunas funciones requieren permisos root.${NC}"
            echo -e "${YELLOW}[!] Ejecuta 'sudo $0' si quieres instalación completa.${NC}"
            echo ""
            read -p "¿Continuar sin root? (s/n): " continue_no_root
            if [[ $continue_no_root != "s" ]]; then
                exit 1
            fi
            USE_SUDO=""
        else
            USE_SUDO=""
        fi
    elif [[ "$PLATFORM" == "termux" ]]; then
        USE_SUDO=""
    elif [[ "$PLATFORM" == "windows" ]]; then
        USE_SUDO=""
    fi
}

# Instalar dependencias
install_dependencies() {
    echo -e "${BLUE}[*] Instalando dependencias...${NC}"
    
    case $PLATFORM in
        termux)
            echo -e "${CYAN}[→] Actualizando repositorios...${NC}"
            pkg update -y
            echo -e "${CYAN}[→] Instalando nmap...${NC}"
            pkg install nmap -y
            echo -e "${CYAN}[→] Instalando python3...${NC}"
            pkg install python3 -y
            echo -e "${CYAN}[→] Instalando pip...${NC}"
            pkg install python-pip -y
            echo -e "${CYAN}[→] Instalando xmltodict para JSON...${NC}"
            pip install xmltodict
            ;;
        
        linux)
            echo -e "${CYAN}[→] Actualizando repositorios...${NC}"
            sudo apt update -y
            echo -e "${CYAN}[→] Instalando nmap...${NC}"
            sudo apt install nmap -y
            echo -e "${CYAN}[→] Instalando python3 y pip...${NC}"
            sudo apt install python3 python3-pip -y
            echo -e "${CYAN}[→] Instalando xmltodict...${NC}"
            pip3 install xmltodict --break-system-packages 2>/dev/null || pip3 install xmltodict
            echo -e "${CYAN}[→] Instalando curl...${NC}"
            sudo apt install curl -y
            ;;
        
        windows)
            echo -e "${YELLOW}[!] Windows: Instalación manual requerida${NC}"
            echo -e "${CYAN}[→] Verificando nmap...${NC}"
            if command -v nmap &> /dev/null; then
                echo -e "${GREEN}[✓] Nmap encontrado${NC}"
            else
                echo -e "${RED}[✗] Nmap no encontrado${NC}"
                echo -e "${YELLOW}Descarga Nmap desde: https://nmap.org/download.html${NC}"
                echo -e "${YELLOW}Agrega Nmap al PATH durante la instalación.${NC}"
            fi
            
            echo -e "${CYAN}[→] Verificando python3...${NC}"
            if command -v python &> /dev/null || command -v python3 &> /dev/null; then
                echo -e "${GREEN}[✓] Python encontrado${NC}"
                pip install xmltodict 2>/dev/null || python -m pip install xmltodict
            else
                echo -e "${RED}[✗] Python3 no encontrado${NC}"
                echo -e "${YELLOW}Descarga Python desde: https://www.python.org/downloads/${NC}"
            fi
            ;;
    esac
}

# Verificar instalación de dependencias
verify_dependencies() {
    echo -e "${BLUE}[*] Verificando instalación...${NC}"
    local deps_ok=true
    
    if ! command -v nmap &> /dev/null; then
        echo -e "${RED}[✗] Nmap no instalado correctamente${NC}"
        deps_ok=false
    else
        echo -e "${GREEN}[✓] Nmap: $(nmap --version | head -1)${NC}"
    fi
    
    if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
        echo -e "${RED}[✗] Python no encontrado (opcional para JSON)${NC}"
    else
        echo -e "${GREEN}[✓] Python disponible${NC}"
    fi
    
    if [[ $deps_ok == false ]]; then
        echo -e "${RED}[!] Faltan dependencias críticas. Revisa los mensajes anteriores.${NC}"
        exit 1
    fi
}

# Copiar script principal
install_scanner() {
    echo -e "${BLUE}[*] Instalando Mx-Scanner...${NC}"
    
    # Verificar que existe mx-scanner.sh
    if [[ ! -f "mx-scanner.sh" ]]; then
        echo -e "${RED}[✗] No se encuentra mx-scanner.sh en el directorio actual${NC}"
        echo -e "${YELLOW}[!] Asegúrate de ejecutar este script desde la carpeta Mx-Scanner${NC}"
        exit 1
    fi
    
    # Copiar según plataforma
    case $PLATFORM in
        termux)
            cp mx-scanner.sh "$PREFIX/bin/mx-scanner"
            chmod +x "$PREFIX/bin/mx-scanner"
            echo -e "${GREEN}[✓] Instalado en $PREFIX/bin/mx-scanner${NC}"
            ;;
        
        linux)
            sudo cp mx-scanner.sh /usr/local/bin/mx-scanner
            sudo chmod +x /usr/local/bin/mx-scanner
            echo -e "${GREEN}[✓] Instalado en /usr/local/bin/mx-scanner${NC}"
            ;;
        
        windows)
            # Para Windows, crear un wrapper .bat
            cp mx-scanner.sh mx-scanner.bat
            echo '@echo off' > mx-scanner.bat
            echo 'bash mx-scanner.sh' >> mx-scanner.bat
            echo -e "${GREEN}[✓] Script listo. Ejecuta ./mx-scanner.sh en Git Bash${NC}"
            echo -e "${YELLOW}[→] O usa 'bash mx-scanner.sh' desde cualquier terminal${NC}"
            ;;
    esac
}

# Crear directorio de configuración
create_config_dirs() {
    echo -e "${BLUE}[*] Creando estructura de directorios...${NC}"
    
    if [[ "$PLATFORM" == "termux" ]]; then
        mkdir -p "$HOME/.mx-scanner"
        mkdir -p "$HOME/.mx-scanner/resultados"
        echo -e "${GREEN}[✓] Directorios creados en $HOME/.mx-scanner${NC}"
        
        # Crear archivo de configuración por defecto
        if [[ ! -f "$HOME/.mx-scanner/scan_config.json" ]]; then
            cat > "$HOME/.mx-scanner/scan_config.json" <<EOF
{
  "scans": [],
  "output_format": "json",
  "output_dir": "$HOME/.mx-scanner/resultados",
  "stealth_default": false
}
EOF
            echo -e "${GREEN}[✓] Configuración por defecto creada${NC}"
        fi
    elif [[ "$PLATFORM" == "linux" ]]; then
        mkdir -p "$HOME/.mx-scanner"
        mkdir -p "$HOME/.mx-scanner/resultados"
        echo -e "${GREEN}[✓] Directorios creados en $HOME/.mx-scanner${NC}"
        
        if [[ ! -f "$HOME/.mx-scanner/scan_config.json" ]]; then
            cat > "$HOME/.mx-scanner/scan_config.json" <<EOF
{
  "scans": [],
  "output_format": "json",
  "output_dir": "$HOME/.mx-scanner/resultados",
  "stealth_default": false
}
EOF
            echo -e "${GREEN}[✓] Configuración por defecto creada${NC}"
        fi
    fi
}

# Mostrar instrucciones finales
show_final_instructions() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     Instalación completada con éxito   ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}[*] Cómo usar Mx-Scanner:${NC}"
    
    case $PLATFORM in
        termux|linux)
            echo -e "    ${YELLOW}➤${NC} Ejecuta: ${GREEN}mx-scanner${NC}"
            echo -e "    ${YELLOW}➤${NC} Para ayuda: ${GREEN}mx-scanner --help${NC}"
            ;;
        windows)
            echo -e "    ${YELLOW}➤${NC} En Git Bash: ${GREEN}./mx-scanner.sh${NC}"
            echo -e "    ${YELLOW}➤${NC} O usa: ${GREEN}bash mx-scanner.sh${NC}"
            ;;
    esac
    
    echo ""
    echo -e "${CYAN}[*] Características disponibles:${NC}"
    echo -e "    ${GREEN}✓${NC} Escaneo rápido/completo de puertos"
    echo -e "    ${GREEN}✓${NC} Modo sigilo (Stealth) con evasión básica"
    echo -e "    ${GREEN}✓${NC} Modo scriptable con archivos JSON"
    echo -e "    ${GREEN}✓${NC} Escaneo por lotes (Batch mode)"
    echo -e "    ${GREEN}✓${NC} Exportación a JSON/XML"
    echo -e "    ${GREEN}✓${NC} Detección de SO y escaneo UDP"
    echo ""
    echo -e "${YELLOW}[!] Nota: Algunas funciones requieren permisos root (sudo)${NC}"
    echo -e "${YELLOW}[!} Modo sigilo y UDP necesitan privilegios elevados${NC}"
    echo ""
    read -p "Presiona Enter para salir..."
}

# Función principal
main() {
    detect_platform
    check_privileges
    install_dependencies
    verify_dependencies
    install_scanner
    create_config_dirs
    show_final_instructions
}

# Ejecutar instalación
main
