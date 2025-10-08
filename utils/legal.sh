#!/bin/bash

# HackRell - utils/legal.sh
# Contiene advertencias legales y éticas para el uso de HackRell.

# Cargar utilidades de color
source "$(dirname "$0")"/colors.sh

function display_legal_warning() {
    clear
    print_banner "ADVERTENCIA LEGAL Y ÉTICA"
    echo ""
    print_warning "El uso de HackRell está destinado EXCLUSIVAMENTE para fines de seguridad informática ética, pruebas de penetración autorizadas y auditorías de seguridad en sistemas y redes de su PROPIEDAD o para los cuales tenga PERMISO EXPLÍCITO y ESCRITO del propietario."
    echo ""
    print_error "CUALQUIER USO DE ESTA HERRAMIENTA PARA ACTIVIDADES ILEGALES, MALICIOSAS O NO AUTORIZADAS ESTÁ ESTRICTAMENTE PROHIBIDO Y ES BAJO SU PROPIA RESPONSABILIDAD. EL DESARROLLADOR NO SE HACE RESPONSABLE DEL MAL USO DE ESTE SOFTWARE."
    echo ""
    print_info "Antes de proceder, asegúrese de comprender y aceptar las siguientes condiciones:"
    echo ""
    echo "  1.  Tengo la autorización legal y ética para realizar pruebas en el objetivo."
    echo "  2.  Comprendo las leyes de mi jurisdicción relacionadas con el hacking y la seguridad informática."
    echo "  3.  Asumo toda la responsabilidad por mis acciones al usar HackRell."
    echo "  4.  Utilizaré HackRell de manera responsable y ética."
    echo ""
    print_warning "Si no está de acuerdo con estas condiciones, debe salir de la aplicación inmediatamente."
    echo ""
    print_info "Presione [ENTER] para continuar o [CTRL+C] para salir."
    read -r
}

function check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "Este script debe ejecutarse con privilegios de root (sudo)."
        print_info "Por favor, ejecute: sudo ./menu.sh"
        exit 1
    fi
}

# Función para mostrar la licencia MIT
function display_mit_license() {
    clear
    print_banner "LICENCIA MIT"
    echo ""
    cat LICENSE
    echo ""
    print_info "Presione [ENTER] para volver al menú principal."
    read -r
}

