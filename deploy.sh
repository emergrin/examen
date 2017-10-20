#!/bin/bash
echo "¿Qué desea hacer?, Escriba iniciar o cargar"
read -p "inicializar o cargar " uno
read -p "Introduzca su AWS Access Key " key
read -p "Introduzca su AWS Secret Key " pass
read -p "Introduzca su clave API " api
op=$(echo "$uno" | tr '[:upper:]' '[:lower:]')
if [[ $op == "iniciar" ]]; then
  docker build -t examen:test github.com/emergrin/examen.git
  docker run --name base -t -d -e VAR_OP=inicial -e VAR_ACC=$key -e VAR_KEY=$pass -e VAR_API=$api examen:test
  docker exec -it base bash -c "/opt/src/examen/script_to_S3/launch.sh"
elif [[ $op == "cargar" ]]; then
  respuesta=Y
  while [ $respuesta = "Y" ]
   do
   read -p "escriba las peliculas que quiere buscar: " lista
   echo $lista >> list.txt
   read -p "¿Quiere añadir una pelicula mas? (Y/N): " t
   resp=$(echo "$t" | tr '[:upper:]' '[:lower:]')
   if [[ $resp == "n" ]]; then
     respuesta=N
  fi
  done
  docker build -t examen:test github.com/emergrin/examen.git
  docker run --name base -t -d -e VAR_OP=carga -e VAR_ACC=$key -e VAR_KEY=$pass -e VAR_API=$api examen:test
  docker cp list.csv base:/opt/src/
  docker exec -it base bash -c "/opt/src/examen/script_to_S3/launch.sh"
else
  echo "opción no valida"
fi
