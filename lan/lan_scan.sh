#!/bin/bash

# HackRell - lan/lan_scan.sh
# Realiza escaneos de red LAN para descubrir hosts y puertos abiertos.

# Cargar utilidades de color y legal
source "$(dirname "$0")"/../utils/colors.sh
source "$(dirname "$0")"/../utils/legal.sh

# Directorio para logs
LOG_DIR="/var/log/hackrell"
mkdir -p "$LOG_DIR" # Asegurarse de que el directorio de logs existe

function lan_scan_menu() {
    check_root
    display_legal_warning
    clear
    print_banner "MÓDULO DE ESCANEO LAN"
    echo ""
    print_info "Este módulo realiza escaneos de red para descubrir hosts y puertos abiertos."
    print_warning "Asegúrese de tener los permisos adecuados y de escanear solo redes autorizadas."
    echo ""

    read -p "${C_GREEN}Ingrese el rango de IP a escanear (ej: 192.168.1.0/24): ${C_RESET}" target_ip_range

    if [ -z "$target_ip_range" ]; then
        print_error "El rango de IP no puede estar vacío. Volviendo al menú principal."
        sleep 3
        return 1
    fi

    print_info "Seleccione el tipo de escaneo Nmap:"
    echo "  1. Escaneo rápido (-F)"
    echo "  2. Escaneo de servicios y versiones (-sV)"
    echo "  3. Escaneo de sistema operativo (-O)"
    echo "  4. Escaneo agresivo (-A) (incluye -sV, -O, detección de scripts y traceroute)"
    echo "  5. Escaneo personalizado (ingresar opciones de Nmap)"
    read -p "${C_GREEN}Seleccione una opción: ${C_RESET}" scan_choice

    local nmap_options=""
    case $scan_choice in
        1) nmap_options="-F" ;;
        2) nmap_options="-sV" ;;
        3) nmap_options="-O" ;;
        4) nmap_options="-A" ;;
        5)
            read -p "${C_GREEN}Ingrese las opciones personalizadas de Nmap (ej: -p 1-1000 -sS): ${C_RESET}" custom_options
            nmap_options="$custom_options"
            ;;
        *)
            print_error "Opción inválida. Volviendo al menú principal."
            sleep 3
            return 1
            ;;
    esac

    print_info "Iniciando escaneo Nmap en $target_ip_range con opciones: $nmap_options"
    print_info "Los resultados se guardarán en ${LOG_DIR}/lan_scan_results.txt"
    echo ""

    nmap $nmap_options "$target_ip_range" -oN "${LOG_DIR}/lan_scan_results.txt" 2>&1 | tee -a "$LOG_DIR/lan_scan.log"

    if [ $? -eq 0 ]; then
        print_success "Escaneo Nmap completado. Resultados guardados en ${LOG_DIR}/lan_scan_results.txt"
    else
        print_error "Error durante el escaneo Nmap. Verifique el log para más detalles."
    fi

    echo ""
    print_info "Presione [ENTER] para continuar."
    read -r
}

# Llamar a la función principal si el script se ejecuta directamente
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    lan_scan_menu
fi

