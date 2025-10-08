#!/bin/bash

# HackRell - utils/dict_manager.sh
# Herramienta para gestionar diccionarios de palabras para ataques de fuerza bruta y cracking de contraseñas.

# Cargar utilidades de color
source "$(dirname "$0")"/colors.sh

# Directorio por defecto para diccionarios
DICT_DIR="/usr/share/wordlists"

function display_dict_manager_menu() {
    clear
    print_banner "GESTOR DE DICCIONARIOS"
    echo ""
    print_info "Directorio de diccionarios actual: ${DICT_DIR}"
    echo ""
    echo "  1. Listar diccionarios disponibles"
    echo "  2. Descargar diccionarios comunes (rockyou.txt, etc.)"
    echo "  3. Crear diccionario personalizado (Crunch)"
    echo "  4. Volver al menú principal"
    echo ""
    read -p "${C_GREEN}Seleccione una opción: ${C_RESET}" choice
    case $choice in
        1) list_dictionaries ;;
        2) download_common_dictionaries ;;
        3) create_custom_dictionary ;;
        4) return 0 ;;
        *) print_error "Opción inválida. Intente de nuevo." ; sleep 2 ; display_dict_manager_menu ;;
    esac
}

function list_dictionaries() {
    clear
    print_banner "DICCIONARIOS DISPONIBLES"
    echo ""
    if [ -d "$DICT_DIR" ]; then
        find "$DICT_DIR" -type f -name "*.txt" -o -name "*.lst" -o -name "*.dic" | sed "s|^$DICT_DIR/|  |"
    else
        print_warning "El directorio de diccionarios ${DICT_DIR} no existe."
    fi
    echo ""
    print_info "Presione [ENTER] para continuar."
    read -r
    display_dict_manager_menu
}

function download_common_dictionaries() {
    clear
    print_banner "DESCARGAR DICCIONARIOS COMUNES"
    echo ""
    print_info "Esta función descargará diccionarios populares como rockyou.txt.gz."
    print_warning "Asegúrese de tener suficiente espacio en disco. Se requiere conexión a internet."
    echo ""
    read -p "${C_YELLOW}¿Desea continuar? (s/N): ${C_RESET}" confirm
    if [[ "$confirm" =~ ^[Ss]$ ]]; then
        mkdir -p "$DICT_DIR"
        print_info "Descargando rockyou.txt.gz..."
        wget -c https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt -O "$DICT_DIR/rockyou.txt.gz" 2>&1 | tee -a "$LOG_DIR/dict_manager.log"
        if [ $? -eq 0 ]; then
            print_success "Descarga completa. Descomprimiendo..."
            gzip -d "$DICT_DIR/rockyou.txt.gz" 2>&1 | tee -a "$LOG_DIR/dict_manager.log"
            if [ $? -eq 0 ]; then
                print_success "rockyou.txt descomprimido en ${DICT_DIR}/rockyou.txt"
            else
                print_error "Error al descomprimir rockyou.txt.gz. Verifique el log."
            fi
        else
            print_error "Error al descargar rockyou.txt.gz. Verifique la conexión a internet y el log."
        fi
    else
        print_info "Descarga cancelada."
    fi
    echo ""
    print_info "Presione [ENTER] para continuar."
    read -r
    display_dict_manager_menu
}

function create_custom_dictionary() {
    clear
    print_banner "CREAR DICCIONARIO PERSONALIZADO (CRUNCH)"
    echo ""
    if ! command -v crunch &> /dev/null; then
        print_error "La herramienta 'crunch' no está instalada. No se puede crear un diccionario personalizado."
        print_info "Instálela con: sudo apt install crunch"
        print_info "Presione [ENTER] para continuar."
        read -r
        display_dict_manager_menu
        return 1
    fi

    read -p "${C_GREEN}Longitud mínima de la contraseña: ${C_RESET}" min_len
    read -p "${C_GREEN}Longitud máxima de la contraseña: ${C_RESET}" max_len
    read -p "${C_GREEN}Conjunto de caracteres (ej: abcdefg123): ${C_RESET}" charset
    read -p "${C_GREEN}Nombre del archivo de salida (ej: custom_dict.txt): ${C_RESET}" output_file

    if [ -z "$min_len" ] || [ -z "$max_len" ] || [ -z "$charset" ] || [ -z "$output_file" ]; then
        print_error "Todos los campos son obligatorios."
        print_info "Presione [ENTER] para continuar."
        read -r
        display_dict_manager_menu
        return 1
    fi

    local full_output_path="$DICT_DIR/$output_file"
    print_info "Generando diccionario con crunch... Esto puede tardar mucho y generar archivos grandes."
    print_info "Comando: crunch $min_len $max_len $charset -o $full_output_path"
    echo ""
    read -p "${C_YELLOW}¿Desea continuar? (s/N): ${C_RESET}" confirm
    if [[ "$confirm" =~ ^[Ss]$ ]]; then
        crunch "$min_len" "$max_len" "$charset" -o "$full_output_path" 2>&1 | tee -a "$LOG_DIR/dict_manager.log"
        if [ $? -eq 0 ]; then
            print_success "Diccionario personalizado generado en ${full_output_path}"
        else
            print_error "Error al generar el diccionario. Verifique el log."
        fi
    else
        print_info "Generación de diccionario cancelada."
    fi
    echo ""
    print_info "Presione [ENTER] para continuar."
    read -r
    display_dict_manager_menu
}

