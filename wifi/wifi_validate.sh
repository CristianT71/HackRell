#!/bin/bash

# HackRell - wifi/wifi_validate.sh
# Valida si un archivo .cap contiene un handshake WPA/WPA2 válido.

# Cargar utilidades de color y legal
source "$(dirname "$0")"/../utils/colors.sh
source "$(dirname "$0")"/../utils/legal.sh

# Directorio para logs
LOG_DIR="/var/log/hackrell"
mkdir -p "$LOG_DIR" # Asegurarse de que el directorio de logs existe

function wifi_validate_menu() {
    check_root
    display_legal_warning
    clear
    print_banner "MÓDULO DE VALIDACIÓN WIFI (HANDSHAKES)"
    echo ""
    print_info "Este módulo verificará si un archivo .cap contiene un handshake WPA/WPA2 válido."
    print_warning "Necesitará un archivo .cap capturado previamente."
    echo ""

    read -p "${C_GREEN}Ingrese la ruta al archivo .cap a validar (ej: /var/log/hackrell/handshake-01.cap): ${C_RESET}" cap_file

    if [ ! -f "$cap_file" ]; then
        print_error "Archivo .cap no encontrado: $cap_file. Volviendo al menú principal."
        sleep 3
        return 1
    fi

    print_info "Verificando handshake en $cap_file con aircrack-ng..."
    print_info "Los resultados se guardarán en ${LOG_DIR}/wifi_validate.log"
    echo ""

    # aircrack-ng con la opción -J para exportar a formato hashcat, que implícitamente valida el handshake
    # O simplemente ejecutar aircrack-ng sin diccionario para que muestre si hay handshakes
    aircrack-ng "$cap_file" 2>&1 | tee -a "$LOG_DIR/wifi_validate.log"

    if grep -q "WPA handshake:" "$LOG_DIR/wifi_validate.log"; then
        print_success "¡Handshake WPA/WPA2 válido detectado en $cap_file!"
        print_info "Puede proceder a crackearlo con el módulo de crackeo WiFi."
    else
        print_error "No se detectó un handshake WPA/WPA2 válido en $cap_file."
        print_info "Asegúrese de que el archivo .cap fue capturado correctamente y contiene el handshake."
    fi

    echo ""
    print_info "Presione [ENTER] para continuar."
    read -r
}

# Llamar a la función principal si el script se ejecuta directamente
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    wifi_validate_menu
fi

