#!/bin/bash

# HackRell - lan/lan_enum.sh
# Realiza enumeración de red LAN para descubrir información sobre hosts y servicios.

# Cargar utilidades de color y legal
source "$(dirname "$0")"/../utils/colors.sh
source "$(dirname "$0")"/../utils/legal.sh

# Directorio para logs
LOG_DIR="/var/log/hackrell"
mkdir -p "$LOG_DIR" # Asegurarse de que el directorio de logs existe

function lan_enum_menu() {
    check_root
    display_legal_warning
    clear
    print_banner "MÓDULO DE ENUMERACIÓN LAN"
    echo ""
    print_info "Este módulo realiza enumeración de red para descubrir información detallada sobre hosts y servicios."
    print_warning "La enumeración puede ser detectada por sistemas de seguridad. Úselo solo en redes autorizadas."
    echo ""

    read -p "${C_GREEN}Ingrese la IP del objetivo (ej: 192.168.1.100): ${C_RESET}" target_ip

    if [ -z "$target_ip" ]; then
        print_error "La IP del objetivo no puede estar vacía. Volviendo al menú principal."
        sleep 3
        return 1
    fi

    print_info "Seleccione el tipo de enumeración:"
    echo "  1. Enumeración SMB/NetBIOS (enum4linux)"
    echo "  2. Enumeración SNMP (snmpwalk)"
    echo "  3. Enumeración de usuarios (Nmap scripts)"
    echo "  4. Enumeración DNS (dnsenum)"
    read -p "${C_GREEN}Seleccione una opción: ${C_RESET}" enum_choice

    local log_file="${LOG_DIR}/lan_enum_$(date +%Y%m%d_%H%M%S).log"

    case $enum_choice in
        1)
            if ! command -v enum4linux &> /dev/null; then
                print_error "La herramienta 'enum4linux' no está instalada. No se puede realizar la enumeración SMB."
                print_info "Instálela con: sudo apt install enum4linux"
                print_info "Presione [ENTER] para continuar."
                read -r
                return 1
            fi
            print_info "Iniciando enumeración SMB/NetBIOS en $target_ip con enum4linux."
            print_info "Los resultados se guardarán en $log_file"
            enum4linux -a "$target_ip" 2>&1 | tee -a "$log_file"
            ;;
        2)
            if ! command -v snmpwalk &> /dev/null; then
                print_error "La herramienta 'snmpwalk' no está instalada. No se puede realizar la enumeración SNMP."
                print_info "Instálela con: sudo apt install snmp"
                print_info "Presione [ENTER] para continuar."
                read -r
                return 1
            fi
            print_info "Iniciando enumeración SNMP en $target_ip con snmpwalk."
            print_info "Los resultados se guardarán en $log_file"
            snmpwalk -v 1 -c public "$target_ip" 2>&1 | tee -a "$log_file"
            ;;
        3)
            print_info "Iniciando enumeración de usuarios en $target_ip con scripts de Nmap."
            print_info "Los resultados se guardarán en $log_file"
            nmap -p 139,445 --script smb-enum-users,smb-enum-shares "$target_ip" -oN "$log_file" 2>&1 | tee -a "$LOG_DIR/lan_enum_nmap.log"
            ;;
        4)
            if ! command -v dnsenum &> /dev/null; then
                print_error "La herramienta 'dnsenum' no está instalada. No se puede realizar la enumeración DNS."
                print_info "Instálela con: sudo apt install dnsenum"
                print_info "Presione [ENTER] para continuar."
                read -r
                return 1
            fi
            read -p "${C_GREEN}Ingrese el dominio a enumerar (ej: example.com): ${C_RESET}" target_domain
            if [ -z "$target_domain" ]; then
                print_error "El dominio no puede estar vacío. Volviendo al menú principal."
                sleep 3
                return 1
            fi
            print_info "Iniciando enumeración DNS para $target_domain con dnsenum."
            print_info "Los resultados se guardarán en $log_file"
            dnsenum "$target_domain" 2>&1 | tee -a "$log_file"
            ;;
        *)
            print_error "Opción inválida. Volviendo al menú principal."
            sleep 3
            return 1
            ;;
    esac

    if [ $? -eq 0 ]; then
        print_success "Enumeración completada. Resultados guardados en $log_file"
    else
        print_error "Error durante la enumeración. Verifique el log para más detalles."
    fi

    echo ""
    print_info "Presione [ENTER] para continuar."
    read -r
}

# Llamar a la función principal si el script se ejecuta directamente
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    lan_enum_menu
fi

