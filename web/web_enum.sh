#!/bin/bash

# HackRell - web/web_enum.sh
# Realiza enumeración de servicios web para descubrir directorios, archivos, subdominios y tecnologías.

# Cargar utilidades de color y legal
source "$(dirname "$0")"/../utils/colors.sh
source "$(dirname "$0")"/../utils/legal.sh

# Directorio para logs
LOG_DIR="/var/log/hackrell"
mkdir -p "$LOG_DIR" # Asegurarse de que el directorio de logs existe

function web_enum_menu() {
    check_root
    display_legal_warning
    clear
    print_banner "MÓDULO DE ENUMERACIÓN WEB"
    echo ""
    print_info "Este módulo realiza enumeración de servicios web para descubrir información oculta o relevante."
    print_warning "La enumeración web puede generar mucho tráfico y ser detectada. Úselo solo en objetivos autorizados."
    echo ""

    read -p "${C_GREEN}Ingrese la URL del objetivo (ej: http://example.com o https://target.com): ${C_RESET}" target_url

    if [ -z "$target_url" ]; then
        print_error "La URL del objetivo no puede estar vacía. Volviendo al menú principal."
        sleep 3
        return 1
    fi

    print_info "Seleccione el tipo de enumeración web:"
    echo "  1. Escaneo de directorios y archivos (Dirb/Gobuster)"
    echo "  2. Enumeración de subdominios (Sublist3r/Assetfinder)"
    echo "  3. Detección de tecnologías (WhatWeb)"
    read -p "${C_GREEN}Seleccione una opción: ${C_RESET}" enum_choice

    local log_file="${LOG_DIR}/web_enum_$(date +%Y%m%d_%H%M%S).log"

    case $enum_choice in
        1)
            print_info "Seleccione la herramienta para escaneo de directorios:"
            echo "    1. Dirb"
            echo "    2. Gobuster"
            read -p "${C_GREEN}Seleccione una opción: ${C_RESET}" dir_tool_choice

            local wordlist="/usr/share/wordlists/dirb/common.txt"
            if [ ! -f "$wordlist" ]; then
                print_warning "Diccionario común de Dirb no encontrado. Usando /usr/share/wordlists/rockyou.txt (si existe)."
                wordlist="/usr/share/wordlists/rockyou.txt"
                if [ ! -f "$wordlist" ]; then
                    print_error "No se encontró ningún diccionario. Por favor, gestione los diccionarios en utils/dict_manager.sh."
                    sleep 3
                    return 1
                fi
            fi

            case $dir_tool_choice in
                1)
                    if ! command -v dirb &> /dev/null; then
                        print_error "La herramienta 'dirb' no está instalada. Instálela con: sudo apt install dirb"
                        sleep 3 ; return 1
                    fi
                    print_info "Iniciando escaneo de directorios con Dirb en $target_url usando $wordlist."
                    dirb "$target_url" "$wordlist" -o "$log_file" 2>&1 | tee -a "$log_file"
                    ;;
                2)
                    if ! command -v gobuster &> /dev/null; then
                        print_error "La herramienta 'gobuster' no está instalada. Instálela con: go install github.com/OJ/gobuster/v3@latest"
                        sleep 3 ; return 1
                    fi
                    print_info "Iniciando escaneo de directorios con Gobuster en $target_url usando $wordlist."
                    gobuster dir -u "$target_url" -w "$wordlist" -o "$log_file" 2>&1 | tee -a "$log_file"
                    ;;
                *)
                    print_error "Opción inválida. Volviendo al menú principal."
                    sleep 3 ; return 1
                    ;;
            esac
            ;;
        2)
            if ! command -v sublist3r &> /dev/null; then
                print_error "La herramienta 'sublist3r' no está instalada. Instálela con: pip3 install sublist3r"
                sleep 3 ; return 1
            fi
            print_info "Iniciando enumeración de subdominios para $target_url con Sublist3r."
            sublist3r -d "$(echo $target_url | sed -E 's/https?://' | cut -d'/' -f1)" -o "$log_file" 2>&1 | tee -a "$log_file"
            ;;
        3)
            if ! command -v whatweb &> /dev/null; then
                print_error "La herramienta 'whatweb' no está instalada. Instálela con: sudo apt install whatweb"
                sleep 3 ; return 1
            fi
            print_info "Detectando tecnologías en $target_url con WhatWeb."
            whatweb "$target_url" -v -L "$log_file" 2>&1 | tee -a "$log_file"
            ;;
        *)
            print_error "Opción inválida. Volviendo al menú principal."
            sleep 3
            return 1
            ;;
    esac

    if [ $? -eq 0 ]; then
        print_success "Enumeración web completada. Resultados guardados en $log_file"
    else
        print_error "Error durante la enumeración web. Verifique el log para más detalles."
    fi

    echo ""
    print_info "Presione [ENTER] para continuar."
    read -r
}

# Llamar a la función principal si el script se ejecuta directamente
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    web_enum_menu
fi

