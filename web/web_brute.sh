#!/bin/bash

# HackRell - web/web_brute.sh
# Realiza ataques de fuerza bruta a formularios de autenticación web.

# Cargar utilidades de color y legal
source "$(dirname "$0")"/../utils/colors.sh
source "$(dirname "$0")"/../utils/legal.sh
source "$(dirname "$0")"/../utils/dict_manager.sh # Para la gestión de diccionarios

# Directorio para logs
LOG_DIR="/var/log/hackrell"
mkdir -p "$LOG_DIR" # Asegurarse de que el directorio de logs existe

function web_brute_menu() {
    check_root
    display_legal_warning
    clear
    print_banner "MÓDULO DE FUERZA BRUTA WEB"
    echo ""
    print_info "Este módulo realiza ataques de fuerza bruta a formularios de autenticación web."
    print_warning "Los ataques de fuerza bruta pueden bloquear cuentas o IPs. Úselo solo en objetivos autorizados."
    echo ""

    read -p "${C_GREEN}Ingrese la URL del formulario de login (ej: http://example.com/login.php): ${C_RESET}" target_url
    read -p "${C_GREEN}Ingrese el parámetro del nombre de usuario (ej: username): ${C_RESET}" username_param
    read -p "${C_GREEN}Ingrese el parámetro de la contraseña (ej: password): ${C_RESET}" password_param
    read -p "${C_GREEN}Ingrese el nombre de usuario a probar (o la ruta a un archivo de usuarios): ${C_RESET}" username_input
    read -p "${C_GREEN}Ingrese la cadena de error de login (ej: Invalid credentials): ${C_RESET}" error_string

    if [ -z "$target_url" ] || [ -z "$username_param" ] || [ -z "$password_param" ] || [ -z "$username_input" ] || [ -z "$error_string" ]; then
        print_error "Todos los campos son obligatorios. Volviendo al menú principal."
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

    print_info "Iniciando ataque de fuerza bruta web con Hydra..."
    print_info "Objetivo: $target_url"
    print_info "Usuario(s): $username_input"
    print_info "Diccionario: $wordlist_file"
    print_info "Los resultados se guardarán en ${LOG_DIR}/web_brute.log"
    echo ""

    local hydra_command_prefix="hydra -V -f -o ${LOG_DIR}/web_brute_found.txt"
    local hydra_target_options="$target_url http-post-form \"$username_param=^USER^&$password_param=^PASS^:$error_string\""

    if [ -f "$username_input" ]; then
        # Si username_input es un archivo, usar -L
        hydra_command="$hydra_command_prefix -L $username_input -P $wordlist_file $hydra_target_options"
    else
        # Si username_input es un solo usuario, usar -l
        hydra_command="$hydra_command_prefix -l $username_input -P $wordlist_file $hydra_target_options"
    fi

    eval "$hydra_command" 2>&1 | tee -a "$LOG_DIR/web_brute.log"

    if [ -s "${LOG_DIR}/web_brute_found.txt" ]; then
        print_success "¡Credenciales encontradas! Verifique ${LOG_DIR}/web_brute_found.txt"
    else
        print_warning "No se encontraron credenciales con el diccionario proporcionado."
    fi

    echo ""
    print_info "Presione [ENTER] para continuar."
    read -r
}

# Llamar a la función principal si el script se ejecuta directamente
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    web_brute_menu
fi

