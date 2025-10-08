#!/bin/bash

# HackRell - lan/lan_sniff.sh
# Realiza sniffing de red para capturar y analizar tráfico.

# Cargar utilidades de color y legal
source "$(dirname "$0")"/../utils/colors.sh
source "$(dirname "$0")"/../utils/legal.sh

# Directorio para logs y capturas
LOG_DIR="/var/log/hackrell"
mkdir -p "$LOG_DIR" # Asegurarse de que el directorio de logs existe

function select_network_interface() {
    local interfaces=$(ip -o link show | awk -F': ' '{print $2}' | grep -v "lo")
    if [ -z "$interfaces" ]; then
        print_error "No se encontraron interfaces de red. Asegúrese de que su sistema tenga interfaces activas."
        return 1
    fi

    echo "${C_CYAN}Interfaces de red disponibles:${C_RESET}"
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

function lan_sniff_menu() {
    check_root
    display_legal_warning
    clear
    print_banner "MÓDULO DE SNIFFING LAN"
    echo ""
    print_info "Este módulo permite capturar y analizar el tráfico de red."
    print_warning "El sniffing de red sin autorización es ilegal. Úselo solo en redes propias o con permiso explícito."
    echo ""

    local iface_selected=$(select_network_interface)
    if [ -z "$iface_selected" ]; then
        print_error "No se pudo seleccionar una interfaz de red. Volviendo al menú principal."
        sleep 3
        return 1
    fi

    print_info "Seleccione la herramienta de sniffing:"
    echo "  1. tcpdump (captura de paquetes)"
    echo "  2. tshark (análisis de paquetes)"
    read -p "${C_GREEN}Seleccione una opción: ${C_RESET}" sniff_tool_choice

    local capture_file="${LOG_DIR}/lan_sniff_$(date +%Y%m%d_%H%M%S).pcap"

    case $sniff_tool_choice in
        1)
            print_info "Iniciando captura de paquetes con tcpdump en $iface_selected."
            print_info "La captura se guardará en $capture_file. Presione CTRL+C para detener."
            echo ""
            tcpdump -i "$iface_selected" -w "$capture_file" 2>&1 | tee -a "$LOG_DIR/lan_sniff.log"
            if [ $? -eq 0 ]; then
                print_success "Captura de tcpdump completada. Archivo guardado en $capture_file."
            else
                print_error "Error durante la captura con tcpdump. Verifique el log."
            fi
            ;;
        2)
            print_info "Iniciando análisis de paquetes con tshark en $iface_selected."
            print_info "Los resultados se mostrarán en tiempo real. Presione CTRL+C para detener."
            echo ""
            tshark -i "$iface_selected" -w "$capture_file" 2>&1 | tee -a "$LOG_DIR/lan_sniff.log"
            if [ $? -eq 0 ]; then
                print_success "Captura de tshark completada. Archivo guardado en $capture_file."
                print_info "Para analizar el archivo, use: tshark -r $capture_file"
            else
                print_error "Error durante la captura con tshark. Verifique el log."
            fi
            ;;
        *)
            print_error "Opción inválida. Volviendo al menú principal."
            sleep 3
            return 1
            ;;
    esac

    echo ""
    print_info "Presione [ENTER] para continuar."
    read -r
}

# Llamar a la función principal si el script se ejecuta directamente
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    lan_sniff_menu
fi

