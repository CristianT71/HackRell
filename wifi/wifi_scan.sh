#!/bin/bash

# HackRell - wifi/wifi_scan.sh
# Escanea redes WiFi disponibles y muestra información relevante.

# Cargar utilidades de color y legal
source "$(dirname "$0")"/../utils/colors.sh
source "$(dirname "$0")"/../utils/legal.sh

# Directorio para logs
LOG_DIR="/var/log/hackrell"
mkdir -p "$LOG_DIR" # Asegurarse de que el directorio de logs existe

function start_monitor_mode() {
    local iface="$1"
    print_info "Intentando iniciar modo monitor en $iface..."
    # Detener servicios que puedan interferir
    systemctl stop NetworkManager > /dev/null 2>&1
    systemctl stop wpa_supplicant > /dev/null 2>&1

    ifconfig "$iface" down > /dev/null 2>&1
    iwconfig "$iface" mode monitor > /dev/null 2>&1
    ifconfig "$iface" up > /dev/null 2>&1
    if iwconfig "$iface" | grep -q "Mode:Monitor"; then
        print_success "Modo monitor iniciado en $iface."
        return 0
    else
        print_error "No se pudo iniciar el modo monitor en $iface. Verifique si el adaptador lo soporta o si hay procesos que lo bloquean."
        return 1
    fi
}

function stop_monitor_mode() {
    local iface="$1"
    print_info "Deteniendo modo monitor en $iface..."
    ifconfig "$iface" down > /dev/null 2>&1
    iwconfig "$iface" mode managed > /dev/null 2>&1
    ifconfig "$iface" up > /dev/null 2>&1
    # Reiniciar servicios de red
    systemctl start NetworkManager > /dev/null 2>&1
    systemctl start wpa_supplicant > /dev/null 2>&1
    print_success "Modo monitor detenido en $iface."
}

function select_wifi_interface() {
    local interfaces=$(iwconfig 2>/dev/null | grep -oP "^\S+(?=\s+IEEE 802.11)")
    if [ -z "$interfaces" ]; then
        print_error "No se encontraron interfaces inalámbricas. Asegúrese de que su adaptador WiFi esté conectado y sea compatible."
        return 1
    fi

    echo "${C_CYAN}Interfaces inalámbricas disponibles:${C_RESET}"
    select iface in $interfaces; do
        if [ -n "$iface" ]; then
            echo "${C_GREEN}Ha seleccionado: $iface${C_RESET}"
            echo "$iface"
            return 0
        else
            print_error "Selección inválida. Intente de nuevo."
        fi
    done
}

function wifi_scan_menu() {
    check_root
    display_legal_warning
    clear
    print_banner "MÓDULO DE ESCANEO WIFI"
    echo ""
    print_info "Este módulo escaneará redes WiFi cercanas."
    print_warning "Asegúrese de tener un adaptador WiFi compatible y los permisos necesarios."
    echo ""

    local iface_selected=$(select_wifi_interface)
    if [ -z "$iface_selected" ]; then
        print_error "No se pudo seleccionar una interfaz WiFi. Volviendo al menú principal."
        sleep 3
        return 1
    fi

    start_monitor_mode "$iface_selected"
    if [ $? -ne 0 ]; then
        print_error "No se pudo iniciar el modo monitor. Volviendo al menú principal."
        sleep 3
        return 1
    fi

    print_info "Iniciando escaneo de redes WiFi con airodump-ng. Presione CTRL+C para detener el escaneo."
    print_info "Los resultados se guardarán en ${LOG_DIR}/wifi_scan.log y archivos con prefijo wifi_scan_output."
    echo ""

    # Iniciar airodump-ng en segundo plano y redirigir su salida a un archivo de log
    airodump-ng "$iface_selected" -w "${LOG_DIR}/wifi_scan_output" --output-format csv,netxml,kismet 2>&1 | tee -a "$LOG_DIR/wifi_scan.log" &
    local airodump_pid=$!

    print_info "Airodump-ng está escaneando. Presione [ENTER] para detener el escaneo y ver los resultados."
    read -r

    kill "$airodump_pid"
    wait "$airodump_pid" 2>/dev/null

    print_success "Escaneo detenido. Resultados guardados en ${LOG_DIR}/wifi_scan_output-01.csv y otros formatos."
    print_info "Puede ver los detalles en el archivo CSV o NETXML generado."
    echo ""
    print_info "Presione [ENTER] para continuar."
    read -r

    stop_monitor_mode "$iface_selected"
}

# Llamar a la función principal si el script se ejecuta directamente
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    wifi_scan_menu
fi

