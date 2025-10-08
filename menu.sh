#!/bin/bash

# HackRell - menu.sh
# Menú interactivo principal para la suite de hacking ético HackRell.

# Cargar utilidades de color y legal
source "$(dirname "$0")"/utils/colors.sh
source "$(dirname "$0")"/utils/legal.sh
source "$(dirname "$0")"/utils/diagnostic.sh
source "$(dirname "$0")"/utils/dict_manager.sh

# Cargar módulos
source "$(dirname "$0")"/wifi/wifi_scan.sh
source "$(dirname "$0")"/wifi/wifi_capture.sh
source "$(dirname "$0")"/wifi/wifi_crack.sh
source "$(dirname "$0")"/wifi/wifi_validate.sh
source "$(dirname "$0")"/lan/lan_scan.sh
source "$(dirname "$0")"/lan/lan_sniff.sh
source "$(dirname "$0")"/lan/lan_mitm.sh
source "$(dirname "$0")"/lan/lan_enum.sh
source "$(dirname "$0")"/web/web_enum.sh
source "$(dirname "$0")"/web/web_vuln.sh
source "$(dirname "$0")"/web/web_brute.sh
source "$(dirname "$0")"/brute/brute_ssh.sh
source "$(dirname "$0")"/brute/brute_ftp.sh
source "$(dirname "$0")"/brute/brute_telnet.sh
source "$(dirname "$0")"/brute/brute_form.sh
source "$(dirname "$0")"/malware/malware_static.sh
source "$(dirname "$0")"/malware/malware_dynamic.sh
source "$(dirname "$0")"/crypto/crypto_crack.sh

# Función para mostrar el banner principal
function show_main_banner() {
    clear
    echo -e "${C_CYAN}${BOLD}"
    echo "  _    _             _    _ _           "
    echo " | |  | |           | |  | | |          "
    echo " | |__| | __ _ _ __ | |__| | | ___ _ __ "
    echo " |  __  |/ _` | \'__||  __  | |/ _ \'__| "
    echo " | |  | | (_| | |   | |  | | |  __/ |    "
    echo " |_|  |_|\__,_|_|   |_|  |_|_|\___|_|    "
    echo "                                        "
    echo "  ${C_YELLOW}Professional Ethical Hacking Suite${C_RESET}${C_CYAN}${BOLD}"
    echo "  Version: 1.0.0                          "
    echo "  Author: CristianT71                     "
    echo "  GitHub: https://github.com/CristianT71/HackRell"
    echo -e "${C_RESET}"
}

# Función para el menú principal
function main_menu() {
    while true; do
        show_main_banner
        print_info "Menú Principal - Seleccione un módulo:"
        echo ""
        echo "  ${C_YELLOW}[1]${C_RESET} Auditoría WiFi"
        echo "  ${C_YELLOW}[2]${C_RESET} Escaneo y Sniffing LAN"
        echo "  ${C_YELLOW}[3]${C_RESET} Auditoría Web"
        echo "  ${C_YELLOW}[4]${C_RESET} Ataques de Fuerza Bruta"
        echo "  ${C_YELLOW}[5]${C_RESET} Análisis de Malware"
        echo "  ${C_YELLOW}[6]${C_RESET} Crackeo de Criptografía"
        echo "  ${C_YELLOW}[7]${C_RESET} Utilidades (Diagnóstico, Diccionarios, Legal)"
        echo "  ${C_RED}[0]${C_RESET} Salir"
        echo ""
        read -p "${C_GREEN}Seleccione una opción: ${C_RESET}" choice

        case $choice in
            1) wifi_menu ;;
            2) lan_menu ;;
            3) web_menu ;;
            4) brute_menu ;;
            5) malware_menu ;;
            6) crypto_menu ;;
            7) utils_menu ;;
            0) print_info "Saliendo de HackRell. ¡Hasta pronto!"; exit 0 ;;
            *) print_error "Opción inválida. Intente de nuevo."; sleep 2 ;;
        esac
    done
}

# Menú de Auditoría WiFi
function wifi_menu() {
    while true; do
        clear
        print_banner "MÓDULO DE AUDITORÍA WIFI"
        echo ""
        print_info "Seleccione una opción:"
        echo ""
        echo "  ${C_YELLOW}[1]${C_RESET} Escaneo de Redes WiFi (airodump-ng)"
        echo "  ${C_YELLOW}[2]${C_RESET} Captura de Handshakes WPA/WPA2 (airodump-ng, aireplay-ng)"
        echo "  ${C_YELLOW}[3]${C_RESET} Crackeo de Handshakes WPA/WPA2 (aircrack-ng)"
        echo "  ${C_YELLOW}[4]${C_RESET} Validación de Handshakes WPA/WPA2"
        echo "  ${C_RED}[0]${C_RESET} Volver al Menú Principal"
        echo ""
        read -p "${C_GREEN}Seleccione una opción: ${C_RESET}" choice

        case $choice in
            1) wifi_scan_menu ;;
            2) wifi_capture_menu ;;
            3) wifi_crack_menu ;;
            4) wifi_validate_menu ;;
            0) return ;;
            *) print_error "Opción inválida. Intente de nuevo."; sleep 2 ;;
        esac
    done
}

# Menú de Escaneo y Sniffing LAN
function lan_menu() {
    while true; do
        clear
        print_banner "MÓDULO DE ESCANEO Y SNIFFING LAN"
        echo ""
        print_info "Seleccione una opción:"
        echo ""
        echo "  ${C_YELLOW}[1]${C_RESET} Escaneo de Red (Nmap)"
        echo "  ${C_YELLOW}[2]${C_RESET} Sniffing de Tráfico (tcpdump/tshark)"
        echo "  ${C_YELLOW}[3]${C_RESET} Ataques Man-in-the-Middle (Ettercap)"
        echo "  ${C_YELLOW}[4]${C_RESET} Enumeración de Red (SMB, SNMP, DNS)"
        echo "  ${C_RED}[0]${C_RESET} Volver al Menú Principal"
        echo ""
        read -p "${C_GREEN}Seleccione una opción: ${C_RESET}" choice

        case $choice in
            1) lan_scan_menu ;;
            2) lan_sniff_menu ;;
            3) lan_mitm_menu ;;
            4) lan_enum_menu ;;
            0) return ;;
            *) print_error "Opción inválida. Intente de nuevo."; sleep 2 ;;
        esac
    done
}

# Menú de Auditoría Web
function web_menu() {
    while true; do
        clear
        print_banner "MÓDULO DE AUDITORÍA WEB"
        echo ""
        print_info "Seleccione una opción:"
        echo ""
        echo "  ${C_YELLOW}[1]${C_RESET} Enumeración Web (Directorios, Subdominios, Tech)"
        echo "  ${C_YELLOW}[2]${C_RESET} Escaneo de Vulnerabilidades Web (Nikto, WPScan, SQLMap)"
        echo "  ${C_YELLOW}[3]${C_RESET} Fuerza Bruta de Formularios Web (Hydra)"
        echo "  ${C_RED}[0]${C_RESET} Volver al Menú Principal"
        echo ""
        read -p "${C_GREEN}Seleccione una opción: ${C_RESET}" choice

        case $choice in
            1) web_enum_menu ;;
            2) web_vuln_menu ;;
            3) web_brute_menu ;;
            0) return ;;
            *) print_error "Opción inválida. Intente de nuevo."; sleep 2 ;;
        esac
    done
}

# Menú de Ataques de Fuerza Bruta
function brute_menu() {
    while true; do
        clear
        print_banner "MÓDULO DE ATAQUES DE FUERZA BRUTA"
        echo ""
        print_info "Seleccione una opción:"
        echo ""
        echo "  ${C_YELLOW}[1]${C_RESET} Fuerza Bruta SSH (Hydra)"
        echo "  ${C_YELLOW}[2]${C_RESET} Fuerza Bruta FTP (Hydra)"
        echo "  ${C_YELLOW}[3]${C_RESET} Fuerza Bruta Telnet (Hydra)"
        echo "  ${C_YELLOW}[4]${C_RESET} Fuerza Bruta de Formularios Web (Hydra)"
        echo "  ${C_RED}[0]${C_RESET} Volver al Menú Principal"
        echo ""
        read -p "${C_GREEN}Seleccione una opción: ${C_RESET}" choice

        case $choice in
            1) brute_ssh_menu ;;
            2) brute_ftp_menu ;;
            3) brute_telnet_menu ;;
            4) brute_form_menu ;;
            0) return ;;
            *) print_error "Opción inválida. Intente de nuevo."; sleep 2 ;;
        esac
    done
}

# Menú de Análisis de Malware
function malware_menu() {
    while true; do
        clear
        print_banner "MÓDULO DE ANÁLISIS DE MALWARE"
        echo ""
        print_info "Seleccione una opción:"
        echo ""
        echo "  ${C_YELLOW}[1]${C_RESET} Análisis Estático (strings, binwalk, readelf)"
        echo "  ${C_YELLOW}[2]${C_RESET} Análisis Dinámico (strace, ltrace - ¡CUIDADO!)"
        echo "  ${C_RED}[0]${C_RESET} Volver al Menú Principal"
        echo ""
        read -p "${C_GREEN}Seleccione una opción: ${C_RESET}" choice

        case $choice in
            1) malware_static_menu ;;
            2) malware_dynamic_menu ;;
            0) return ;;
            *) print_error "Opción inválida. Intente de nuevo."; sleep 2 ;;
        esac
    done
}

# Menú de Crackeo de Criptografía
function crypto_menu() {
    while true; do
        clear
        print_banner "MÓDULO DE CRACKEO DE CRIPTOGRAFÍA"
        echo ""
        print_info "Seleccione una opción:"
        echo ""
        echo "  ${C_YELLOW}[1]${C_RESET} Crackeo de Hashes (John the Ripper)"
        echo "  ${C_RED}[0]${C_RESET} Volver al Menú Principal"
        echo ""
        read -p "${C_GREEN}Seleccione una opción: ${C_RESET}" choice

        case $choice in
            1) crypto_crack_menu ;;
            0) return ;;
            *) print_error "Opción inválida. Intente de nuevo."; sleep 2 ;;
        esac
    done
}

# Menú de Utilidades
function utils_menu() {
    while true; do
        clear
        print_banner "MÓDULO DE UTILIDADES"
        echo ""
        print_info "Seleccione una opción:"
        echo ""
        echo "  ${C_YELLOW}[1]${C_RESET} Diagnóstico del Sistema"
        echo "  ${C_YELLOW}[2]${C_RESET} Gestor de Diccionarios"
        echo "  ${C_YELLOW}[3]${C_RESET} Ver Licencia MIT"
        echo "  ${C_RED}[0]${C_RESET} Volver al Menú Principal"
        echo ""
        read -p "${C_GREEN}Seleccione una opción: ${C_RESET}" choice

        case $choice in
            1) run_full_diagnostic ;;
            2) display_dict_manager_menu ;;
            3) display_mit_license ;;
            0) return ;;
            *) print_error "Opción inválida. Intente de nuevo."; sleep 2 ;;
        esac
    done
}

# Ejecutar el menú principal al iniciar el script
check_root
display_legal_warning
main_menu

