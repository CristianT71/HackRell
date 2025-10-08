#!/bin/bash

# HackRell - utils/diagnostic.sh
# Realiza diagnósticos del sistema para asegurar la compatibilidad y la disponibilidad de herramientas.

# Cargar utilidades de color
source "$(dirname "$0")"/colors.sh

# Directorio para logs
LOG_DIR="/var/log/hackrell"
mkdir -p "$LOG_DIR" # Asegurarse de que el directorio de logs existe

function check_dependencies() {
    print_info "Verificando dependencias del sistema..."
    local missing_tools=()
    local tools=("aircrack-ng" "nmap" "hydra" "john" "hashcat" "nikto" "dirb" "tcpdump" "iwconfig" "macchanger" "ettercap" "tshark" "crunch" "sqlmap" "gobuster" "wpscan" "metasploit-framework" "binwalk" "ltrace" "strings" "xterm")

    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done

    if [ ${#missing_tools[@]} -eq 0 ]; then
        print_success "Todas las dependencias necesarias están instaladas."
        return 0
    else
        print_warning "Faltan algunas herramientas esenciales. HackRell podría no funcionar correctamente."
        echo "Herramientas faltantes: ${missing_tools[*]}"
        print_info "Considere instalarlas manualmente o ejecutar 'sudo ./install.sh' para intentar una instalación automática."
        return 1
    fi
}

function check_network_interfaces() {
    print_info "Verificando interfaces de red..."
    local wireless_interfaces=$(iwconfig 2>/dev/null | grep -oP '^\S+(?=\s+IEEE 802.11)')
    if [ -z "$wireless_interfaces" ]; then
        print_warning "No se detectaron interfaces inalámbricas. Los módulos WiFi no funcionarán."
        return 1
    else
        print_success "Interfaces inalámbricas detectadas: ${wireless_interfaces[*]}"
        return 0
    fi
}

function check_monitor_mode_support() {
    print_info "Verificando soporte para modo monitor..."
    local wireless_interfaces=$(iwconfig 2>/dev/null | grep -oP '^\S+(?=\s+IEEE 802.11)')
    local monitor_mode_supported=0
    for iface in $wireless_interfaces; do
        if iw list | grep -q "monitor"; then
            print_success "La interfaz '$iface' soporta modo monitor."
            monitor_mode_supported=1
            break
        fi
    done

    if [ $monitor_mode_supported -eq 0 ]; then
        print_warning "Ninguna interfaz inalámbrica detectada soporta modo monitor. Los módulos de auditoría WiFi avanzada podrían no funcionar."
        return 1
    else
        return 0
    fi
}

function run_full_diagnostic() {
    print_banner "DIAGNÓSTICO DEL SISTEMA HACKRELL"
    check_root
    check_dependencies
    check_network_interfaces
    check_monitor_mode_support
    print_info "Diagnóstico completado. Revise las advertencias si las hay."
    print_info "Presione [ENTER] para continuar."
    read -r
}

# La función check_root ya está en legal.sh, pero la incluimos aquí para que diagnostic.sh pueda ser independiente si se llama directamente.
# Si se incluye en menu.sh, se usará la de legal.sh.
function check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "Este script debe ejecutarse con privilegios de root (sudo)."
        print_info "Por favor, ejecute: sudo ./menu.sh"
        exit 1
    fi
}

