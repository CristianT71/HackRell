#!/bin/bash

# HackRell - crypto/crypto_crack.sh
# Realiza ataques de crackeo de hashes de contraseñas utilizando John the Ripper.

# Cargar utilidades de color y legal
source "$(dirname "$0")"/../utils/colors.sh
source "$(dirname "$0")"/../utils/legal.sh
source "$(dirname "$0")"/../utils/dict_manager.sh # Para la gestión de diccionarios

# Directorio para logs
LOG_DIR="/var/log/hackrell"
mkdir -p "$LOG_DIR" # Asegurarse de que el directorio de logs existe

function crypto_crack_menu() {
    check_root
    display_legal_warning
    clear
    print_banner "MÓDULO DE CRACKEO DE HASHES (JOHN THE RIPPER)"
    echo ""
    print_info "Este módulo intentará crackear hashes de contraseñas utilizando John the Ripper."
    print_warning "Necesitará un archivo que contenga los hashes y un diccionario de palabras."
    echo ""

    read -p "${C_GREEN}Ingrese la ruta al archivo que contiene los hashes (ej: /home/user/hashes.txt): ${C_RESET}" hash_file

    if [ ! -f "$hash_file" ]; then
        print_error "Archivo de hashes no encontrado: $hash_file. Volviendo al menú principal."
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

    print_info "Iniciando crackeo de hashes con John the Ripper..."
    print_info "Los resultados se guardarán en ${LOG_DIR}/crypto_crack.log"
    echo ""

    john --wordlist="$wordlist_file" "$hash_file" 2>&1 | tee -a "$LOG_DIR/crypto_crack.log"

    if grep -q "Cracked" "$LOG_DIR/crypto_crack.log"; then
        print_success "¡Hashes crackeados! Verifique los resultados con: john --show $hash_file"
    else
        print_warning "No se pudieron crackear los hashes con el diccionario proporcionado."
        print_info "Considere usar un diccionario más grande o un ataque de fuerza bruta."
    fi

    echo ""
    print_info "Presione [ENTER] para continuar."
    read -r
}

# Llamar a la función principal si el script se ejecuta directamente
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    crypto_crack_menu
fi

