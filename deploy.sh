#!/bin/bash
echo "¿Qué desea hacer?, Escriba inicializar o cargar"
read -p "inicializar o cargar " uno
read -p "Introduzca su AWS Access Key " key
read -p "Introduzca su AWS Secret Key " pass
read -p "Introduzca su clave API " api

op=$(echo "$uno" | tr '[:upper:]' '[:lower:]')
if [[ $op == "iniciar" ]]; then
  docker build -t examen:test github.com/emergrin/examen.git
  docker run --name base -t -d -e VAR_OP=inicial -e VAR_ACC=$key -e VAR_KEY=$pass -e VAR_API=$api examen:test
elif [[ $op == "cargar" ]]; then
  docker build -t examen:test github.com/emergrin/examen.git
  docker run --name base -t -d -e VAR_OP=carga -e VAR_ACC=$key -e VAR_KEY=$pass -e VAR_API=$api examen:test
else
  echo "opción no valida"
fi
