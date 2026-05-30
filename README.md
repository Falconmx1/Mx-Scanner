# 🔍 Mx-Scanner

**Mx-Scanner** es una herramienta de escaneo de redes y puertos desarrollada en Bash/Python, compatible con **Windows (Git Bash/WSL)**, **Termux (Android)** y **Linux nativo**. Ideal para auditorías básicas, pentesting educativo y administración de redes.

## ✨ Características
- Escaneo de puertos TCP/UDP
- Detección de sistema operativo básico
- Escaneo de red local (hosts activos)
- Exportación de resultados a JSON/CSV
- Colores personalizados por plataforma
- Bajo consumo de recursos

## 📦 Requisitos por plataforma

| Plataforma | Requisitos |
|------------|-------------|
| Linux      | bash, nmap, curl |
| Termux     | bash, nmap, termux-api (opcional) |
| Windows    | Git Bash, nmap para Windows, WinPcap/Npcap |

![Version](https://img.shields.io/badge/version-1.0-blue)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20Termux%20%7C%20Windows-lightgrey)
![License](https://img.shields.io/badge/license-MIT-green)

## 🚀 Instalación rápida

### Termux/Linux
```bash
git clone https://github.com/Falconmx1/Mx-Scanner.git
cd Mx-Scanner
chmod +x install.sh
./install.sh
mx-scanner

Windows (Git Bash)
git clone https://github.com/Falconmx1/Mx-Scanner.git
cd Mx-Scanner
bash install.sh
./mx-scanner.sh

