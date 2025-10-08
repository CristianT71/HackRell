#!/bin/bash

# HackRell - install.sh
# Script de instalación automática para HackRell.

# Cargar utilidades de color
source "$(dirname "$0")"/utils/colors.sh

# Directorio para logs
LOG_DIR="/var/log/hackrell"
mkdir -p "$LOG_DIR" # Asegurarse de que el directorio de logs existe

function check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "Este script de instalación debe ejecutarse con privilegios de root (sudo)."
        print_info "Por favor, ejecute: sudo ./install.sh"
        exit 1
    fi
}

function install_dependencies() {
    print_banner "INSTALACIÓN DE DEPENDENCIAS HACKRELL"
    print_info "Actualizando listas de paquetes..."
    apt update 2>&1 | tee -a "$LOG_DIR/install.log"
    if [ $? -ne 0 ]; then
        print_warning "No se pudo actualizar las listas de paquetes. Intentando continuar."
    fi

    print_info "Instalando herramientas necesarias..."
    local tools=("aircrack-ng" "nmap" "hydra" "john" "hashcat" "nikto" "dirb" "tcpdump" "iwconfig" "macchanger" "ettercap-text-only" "tshark" "crunch" "sqlmap" "wpscan" "metasploit-framework" "binwalk" "ltrace" "strings" "xterm" "enum4linux" "snmp" "dnsutils" "whatweb" "golang-go" "python3-pip")
    local missing_tools=()

    for tool in "${tools[@]}"; do
        print_info "Verificando $tool..."
        if ! command -v "$tool" &> /dev/null; then
            print_warning "$tool no encontrado. Intentando instalar..."
            apt install -y "$tool" 2>&1 | tee -a "$LOG_DIR/install.log"
            if [ $? -ne 0 ]; then
                print_error "Fallo al instalar $tool. Puede que necesite instalarlo manualmente."
                missing_tools+=("$tool")
            else
                print_success "$tool instalado correctamente."
            fi
        else
            print_success "$tool ya está instalado."
        fi
    done

    # Instalación de gobuster si no está presente (GoLang)
    if ! command -v gobuster &> /dev/null; then
        print_warning "Gobuster no encontrado. Intentando instalar Gobuster..."
        go install github.com/OJ/gobuster/v3@latest 2>&1 | tee -a "$LOG_DIR/install.log"
        if [ $? -eq 0 ]; then
            print_success "Gobuster instalado correctamente."
        else
            print_error "Fallo al instalar Gobuster. Puede que necesite instalarlo manualmente. Asegúrese de que GoLang esté configurado correctamente."
            missing_tools+=("gobuster")
        fi
    fi

    # Instalación de sublist3r si no está presente (Python)
    if ! command -v sublist3r &> /dev/null; then
        print_warning "Sublist3r no encontrado. Intentando instalar Sublist3r..."
        pip3 install sublist3r 2>&1 | tee -a "$LOG_DIR/install.log"
        if [ $? -eq 0 ]; then
            print_success "Sublist3r instalado correctamente."
        else
            print_error "Fallo al instalar Sublist3r. Puede que necesite instalarlo manualmente. Asegúrese de que pip3 esté configurado correctamente."
            missing_tools+=("sublist3r")
        fi
    fi

    if [ ${#missing_tools[@]} -eq 0 ]; then
        print_success "Todas las dependencias principales han sido instaladas o ya estaban presentes."
    else
        print_warning "Algunas herramientas no pudieron ser instaladas automáticamente: ${missing_tools[*]}"
        print_info "Por favor, considere instalarlas manualmente. Revise el log de instalación en $LOG_DIR/install.log"
    fi
}

function setup_permissions() {
    print_info "Configurando permisos de ejecución para los scripts..."
    chmod +x menu.sh install.sh
    find . -type f -name "*.sh" -exec chmod +x {} \;
    print_success "Permisos de ejecución configurados."
}

function main_install() {
    check_root
    install_dependencies
    setup_permissions
    print_success "Instalación de HackRell completada. Puede ejecutar ./menu.sh para iniciar la suite."
    print_info "Presione [ENTER] para salir."
    read -r
}

# Ejecutar la función principal de instalación
main_install

