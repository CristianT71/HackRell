#!/bin/bash

# HackRell - web/web_vuln.sh
# Escanea aplicaciones web en busca de vulnerabilidades conocidas.

# Cargar utilidades de color y legal
source "$(dirname "$0")"/../utils/colors.sh
source "$(dirname "$0")"/../utils/legal.sh

# Directorio para logs
LOG_DIR="/var/log/hackrell"
mkdir -p "$LOG_DIR" # Asegurarse de que el directorio de logs existe

function web_vuln_menu() {
    check_root
    display_legal_warning
    clear
    print_banner "MÓDULO DE ESCANEO DE VULNERABILIDADES WEB"
    echo ""
    print_info "Este módulo escanea aplicaciones web en busca de vulnerabilidades conocidas."
    print_warning "El escaneo de vulnerabilidades puede ser intrusivo y debe realizarse solo en objetivos autorizados."
    echo ""

    read -p "${C_GREEN}Ingrese la URL del objetivo (ej: http://example.com o https://target.com): ${C_RESET}" target_url

    if [ -z "$target_url" ]; then
        print_error "La URL del objetivo no puede estar vacía. Volviendo al menú principal."
        sleep 3
        return 1
    fi

    print_info "Seleccione la herramienta de escaneo de vulnerabilidades:"
    echo "  1. Nikto (escáner de vulnerabilidades de servidor web)"
    echo "  2. WPScan (escáner de vulnerabilidades de WordPress)"
    echo "  3. SQLMap (detección y explotación de inyección SQL)"
    read -p "${C_GREEN}Seleccione una opción: ${C_RESET}" vuln_tool_choice

    local log_file="${LOG_DIR}/web_vuln_$(date +%Y%m%d_%H%M%S).log"

    case $vuln_tool_choice in
        1)
            if ! command -v nikto &> /dev/null; then
                print_error "La herramienta 'nikto' no está instalada. Instálela con: sudo apt install nikto"
                sleep 3 ; return 1
            fi
            print_info "Iniciando escaneo de vulnerabilidades con Nikto en $target_url."
            nikto -h "$target_url" -o "$log_file" 2>&1 | tee -a "$log_file"
            ;;
        2)
            if ! command -v wpscan &> /dev/null; then
                print_error "La herramienta 'wpscan' no está instalada. Instálela con: sudo apt install wpscan"
                sleep 3 ; return 1
            fi
            print_info "Iniciando escaneo de vulnerabilidades con WPScan en $target_url."
            wpscan --url "$target_url" --enumerate vp,vt,u --output "$log_file" 2>&1 | tee -a "$log_file"
            ;;
        3)
            if ! command -v sqlmap &> /dev/null; then
                print_error "La herramienta 'sqlmap' no está instalada. Instálela con: sudo apt install sqlmap"
                sleep 3 ; return 1
            fi
            print_info "Iniciando detección de inyección SQL con SQLMap en $target_url."
            sqlmap -u "$target_url" --batch --crawl=1 --dump --output-dir="${LOG_DIR}/sqlmap_output" 2>&1 | tee -a "$log_file"
            ;;
        *)
            print_error "Opción inválida. Volviendo al menú principal."
            sleep 3
            return 1
            ;;
    esac

    if [ $? -eq 0 ]; then
        print_success "Escaneo de vulnerabilidades web completado. Resultados guardados en $log_file"
        if [ "$vuln_tool_choice" -eq 3 ]; then
            print_info "Resultados detallados de SQLMap en ${LOG_DIR}/sqlmap_output"
        fi
    else
        print_error "Error durante el escaneo de vulnerabilidades web. Verifique el log para más detalles."
    fi

    echo ""
    print_info "Presione [ENTER] para continuar."
    read -r
}

# Llamar a la función principal si el script se ejecuta directamente
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    web_vuln_menu
fi

