# HackRell - Suite de Hacking Ético Profesional

![HackRell Banner](https://copilot.microsoft.com/th/id/BCO.6b6b4868-27ee-4ea1-8a82-0b4ac248bcb9.png) 

## Descripción

HackRell es una suite de hacking ético profesional, funcional y modular, escrita en Bash, diseñada para facilitar auditorías reales en redes WiFi, LAN, servicios web, contraseñas, malware y más. Este proyecto se enfoca en proporcionar herramientas 100% funcionales, sin simulaciones ni decoraciones, utilizando herramientas de pentesting reales y validadas por la comunidad.

Cada módulo de HackRell está diseñado para ejecutar herramientas reales, validar el entorno antes de la ejecución y ofrecer resultados verificables, haciendo de esta suite una herramienta invaluable para hackers éticos y profesionales de la ciberseguridad en entornos reales.

## Características Principales

-   **Modularidad:** Estructura organizada en módulos específicos para diferentes tipos de auditorías.
-   **Funcionalidad Real:** Integración de más de 30 herramientas de hacking ético reales y potentes.
-   **Amplia Cobertura:** Soporte para auditorías WiFi, escaneo LAN, fuerza bruta, enumeración web, análisis de malware, crackeo de contraseñas, ataques criptográficos y más.
-   **Diagnóstico de Compatibilidad:** Herramientas para validar el entorno del sistema y las dependencias.
-   **Gestión de Diccionarios:** Utilidad para descargar y crear diccionarios de palabras.
-   **Interfaz Interactiva:** Menú visual en terminal con colores, banners y navegación intuitiva.
-   **Portabilidad:** Diseñado para ser compatible con Kali Linux, Parrot OS, Ubuntu y Arch Linux.
-   **Documentación Completa:** `README.md` detallado y advertencias legales.
-   **Licencia MIT:** Software de código abierto con una licencia permisiva.

## Estructura del Proyecto

```
. 
├── brute/
│   ├── brute_ftp.sh
│   ├── brute_form.sh
│   ├── brute_ssh.sh
│   └── brute_telnet.sh
├── crypto/
│   └── crypto_crack.sh
├── install.sh
├── lan/
│   ├── lan_enum.sh
│   ├── lan_mitm.sh
│   ├── lan_scan.sh
│   └── lan_sniff.sh
├── LICENSE
├── malware/
│   ├── malware_dynamic.sh
│   └── malware_static.sh
├── menu.sh
├── README.md
├── utils/
│   ├── colors.sh
│   ├── diagnostic.sh
│   ├── dict_manager.sh
│   └── legal.sh
├── web/
│   ├── web_brute.sh
│   ├── web_enum.sh
│   └── web_vuln.sh
└── wifi/
    ├── wifi_capture.sh
    ├── wifi_crack.sh
    ├── wifi_scan.sh
    └── wifi_validate.sh
```

## Requisitos Técnicos

HackRell requiere las siguientes herramientas y dependencias. El script `install.sh` intentará instalarlas automáticamente, pero es posible que algunas requieran intervención manual o que ya estén preinstaladas en distribuciones como Kali Linux o Parrot OS.

-   **Herramientas de Red:** `aircrack-ng`, `nmap`, `tcpdump`, `iwconfig`, `macchanger`, `ettercap`, `tshark`.
-   **Herramientas de Fuerza Bruta/Cracking:** `hydra`, `john`, `hashcat`, `crunch`.
-   **Herramientas Web:** `nikto`, `dirb`, `gobuster`, `wpscan`, `sqlmap`, `whatweb`, `sublist3r`.
-   **Herramientas de Análisis de Binarios/Malware:** `binwalk`, `ltrace`, `strings`, `strace`, `readelf`, `objdump`.
-   **Utilidades del Sistema:** `xterm`, `sudo`, `wget`, `gzip`, `apt` (o equivalente para su distribución).
-   **Lenguajes/Entornos:** `bash`, `python3-pip`, `golang-go`.

## Instalación

Para instalar HackRell y sus dependencias, siga estos pasos:

1.  **Clonar el repositorio (si aún no lo ha hecho):**
    ```bash
    git clone https://github.com/CristianT71/HackRell.git
    cd HackRell
    ```

2.  **Ejecutar el script de instalación:**
    ```bash
    sudo ./install.sh
    ```
    Este script intentará instalar todas las dependencias necesarias y configurar los permisos de ejecución. Es posible que se le pida su contraseña de `sudo`.

## Uso

Para iniciar HackRell, navegue al directorio del proyecto y ejecute el script `menu.sh` con privilegios de root:

```bash
cd HackRell
sudo ./menu.sh
```

Al iniciar, se le presentará una **Advertencia Legal y Ética** que debe leer y aceptar para continuar. Luego, accederá al menú principal donde podrá seleccionar los diferentes módulos.

### Modo Educativo vs. Experto

Actualmente, HackRell opera en un modo que guía al usuario a través de las opciones de cada herramienta. Para un "modo experto" (donde se puedan pasar argumentos directamente a las herramientas), se puede modificar cada script de módulo para aceptar argumentos de línea de comandos o añadir una opción en el menú para ello.

## Advertencias Legales y Éticas

**EL USO DE HACKRELL ESTÁ DESTINADO EXCLUSIVAMENTE PARA FINES DE SEGURIDAD INFORMÁTICA ÉTICA, PRUEBAS DE PENETRACIÓN AUTORIZADAS Y AUDITORÍAS DE SEGURIDAD EN SISTEMAS Y REDES DE SU PROPIEDAD O PARA LOS CUALES TENGA PERMISO EXPLÍCITO Y ESCRITO DEL PROPIETARIO.**

**CUALQUIER USO DE ESTA HERRAMIENTA PARA ACTIVIDADES ILEGALES, MALICIOSAS O NO AUTORIZADAS ESTÁ ESTRICTAMENTE PROHIBIDO Y ES BAJO SU PROPIA RESPONSABILIDAD. EL DESARROLLADOR NO SE HACE RESPONSABLE DEL MAL USO DE ESTE SOFTWARE.**

Antes de ejecutar cualquier módulo, HackRell mostrará una advertencia legal. Es su responsabilidad asegurarse de cumplir con todas las leyes locales e internacionales y de tener la autorización adecuada para cualquier actividad de pentesting.

## Contribuciones

Las contribuciones son bienvenidas. Si desea mejorar HackRell, por favor, siga estos pasos:

1.  Haga un fork del repositorio.
2.  Cree una nueva rama (`git checkout -b feature/nueva-funcionalidad`).
3.  Realice sus cambios y haga commit (`git commit -am \'Añadir nueva funcionalidad\'`).
4.  Suba sus cambios a su fork (`git push origin feature/nueva-funcionalidad`).
5.  Abra un Pull Request.

## Licencia

Este proyecto está bajo la Licencia MIT. Consulte el archivo `LICENSE` para más detalles.

## Contacto

Para preguntas o sugerencias, puede contactar al autor a través de GitHub.

--- 

**© 2025 CristianT71**

