#!/bin/bash

# HackRell - utils/colors.sh
# Define códigos de color para la salida de la terminal.

# Colores de texto
export C_RED="\033[0;31m"
export C_GREEN="\033[0;32m"
export C_YELLOW="\033[0;33m"
export C_BLUE="\033[0;34m"
export C_MAGENTA="\033[0;35m"
export C_CYAN="\033[0;36m"
export C_WHITE="\033[0;37m"
export C_RESET="\033[0m"

# Colores de fondo
export BG_RED="\033[41m"
export BG_GREEN="\033[42m"
export BG_YELLOW="\033[43m"
export BG_BLUE="\033[44m"
export BG_MAGENTA="\033[45m"
export BG_CYAN="\033[46m"
export BG_WHITE="\033[47m"

# Estilos de texto
export BOLD="\033[1m"
export UNDERLINE="\033[4m"
export INVERT="\033[7m"

# Funciones de utilidad para imprimir mensajes con color
function print_info() { echo -e "${C_CYAN}[INFO]${C_RESET} $1"; }
function print_success() { echo -e "${C_GREEN}[ÉXITO]${C_RESET} $1"; }
function print_warning() { echo -e "${C_YELLOW}[ADVERTENCIA]${C_RESET} $1"; }
function print_error() { echo -e "${C_RED}[ERROR]${C_RESET} $1"; }
function print_debug() { echo -e "${C_MAGENTA}[DEBUG]${C_RESET} $1"; }
function print_banner() { echo -e "${C_BLUE}${BOLD}$1${C_RESET}"; }

# Ejemplo de uso (opcional, para pruebas)
# print_info "Este es un mensaje de información."
# print_success "Operación completada con éxito."
# print_warning "Algo inesperado ha ocurrido."
# print_error "Ha ocurrido un error crítico."
# print_banner "HACKRELL"

