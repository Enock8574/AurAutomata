#!/bin/bash

# Función para mostrar el menú
show_menu() {
    echo ""
    echo "======================================"
    echo "             AUR AUTOMATA             "
    echo "======================================"
    echo "1) Ver cambios (Diff con el remoto)"
    echo "2) Actualizar (Pull + Build + Clean)"
    echo "3) Limpieza profunda (Git clean -dfx)"
    echo "4) Solo compilar (makepkg -si)"
    echo "5) Salir"
    echo "======================================"
    echo -n "Seleccione una opción [1-5]: "
}

# Verificación de seguridad inicial
if [[ ! -f "PKGBUILD" ]]; then
    echo "Error: No se encontró un PKGBUILD aquí."
    exit 1
fi

# Bucle interactivo
while true; do
    show_menu
    read opcion

    case $opcion in
        1)
            echo "--> Comparando con el repositorio remoto..."
            git fetch
            git diff --color-words HEAD..origin/master
            ;;
        
        2)
            echo "--> Sincronizando y actualizando..."
            git fetch && git pull
            # -s: dependencias, -i: instalar, -c: limpia build, -r: quita makedepends
            makepkg -sicr
            ;;

        3)
            echo "--> Eliminando archivos temporales y paquetes antiguos..."
            git clean -dfx
            echo "Carpeta limpia como el primer día."
            ;;

        4)
            echo "--> Iniciando compilación rápida..."
            makepkg -si
            ;;

        5)
            echo "Saliendo del gestor. ¡Buen día!"
            break  # Rompe el bucle while y termina el script
            ;;

        *)
            echo "Opción no válida, intenta de nuevo."
            ;;
    esac
done
