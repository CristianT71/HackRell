#!/bin/bash

# HackRell - wifi/wifi_crack.sh
# Crackea handshakes WPA/WPA2 utilizando aircrack-ng o hashcat.

# Cargar utilidades de color y legal
source "$(dirname "$0")"/../utils/colors.sh
source "$(dirname "$0")"/../utils/legal.sh
source "$(dirname "$0")"/../utils/dict_manager.sh # Para la gestión de diccionarios

# Directorio para logs
LOG_DIR="/var/log/hackrell"
mkdir -p "$LOG_DIR" # Asegurarse de que el directorio de logs existe

function wifi_crack_menu() {
    check_root
    display_legal_warning
    clear
    print_banner "MÓDULO DE CRACKEO WIFI (WPA/WPA2)"
    echo ""
    print_info "Este módulo intentará crackear handshakes WPA/WPA2 capturados."
    print_warning "Necesitará un archivo .cap con un handshake válido y un diccionario de palabras."
    echo ""

    read -p "${C_GREEN}Ingrese la ruta al archivo .cap con el handshake (ej: /var/log/hackrell/handshake-01.cap): ${C_RESET}" cap_file

    if [ ! -f "$cap_file" ]; then
        print_error "Archivo .cap no encontrado: $cap_file. Volviendo al menú principal."
        sleep 3
        return 1
    fi

    print_info "Seleccione un diccionario para el ataque:"
    echo "  1. Usar diccionario existente (especificar ruta)"
    echo "  2. Gestionar diccionarios (descargar/crear)"
    read -p "${C_GREEN}Seleccione una opción: ${C_RESET}" dict_choice

    local wordlist_file=""
    case $dict_choice in
        1)
            read -p "${C_GREEN}Ingrese la ruta al diccionario (ej: /usr/share/wordlists/rockyou.txt): ${C_RESET}" wordlist_file
            if [ ! -f "$wordlist_file" ]; then
                print_error "Diccionario no encontrado: $wordlist_file. Volviendo al menú principal."
                sleep 3
                return 1
            fi
            ;;
        2)
            display_dict_manager_menu
            print_info "Por favor, ingrese la ruta al diccionario después de gestionarlos:"
            read -p "${C_GREEN}Ruta al diccionario: ${C_RESET}" wordlist_file
            if [ ! -f "$wordlist_file" ]; then
                print_error "Diccionario no encontrado: $wordlist_file. Volviendo al menú principal."
                sleep 3
                return 1
            fi
            ;;
        *)
            print_error "Opción inválida. Volviendo al menú principal."
            sleep 3
            return 1
            ;;
    esac

    print_info "Iniciando ataque de diccionario con aircrack-ng..."
    print_info "Los resultados se guardarán en ${LOG_DIR}/wifi_crack.log"
    echo ""

    aircrack-ng "$cap_file" -w "$wordlist_file" 2>&1 | tee -a "$LOG_DIR/wifi_crack.log"

    if grep -q "KEY FOUND!" "$LOG_DIR/wifi_crack.log"; then
        local password=$(grep "KEY FOUND!" "$LOG_DIR/wifi_crack.log" | awk -F\'[]\' \'{print $2}\')
        print_success "¡Contraseña encontrada! La contraseña es: ${BOLD}${password}${C_RESET}"
    else
        print_warning "Contraseña no encontrada con el diccionario proporcionado."
        print_info "Considere usar un diccionario más grande o un ataque de fuerza bruta."
    fi

    echo ""
    print_info "Presione [ENTER] para continuar."
    read -r
}

# Llamar a la función principal si el script se ejecuta directamente
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    wifi_crack_menu
fi

