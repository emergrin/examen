#!/bin/bash

function err_ {
if [ $? != 0 ]; then
      echo "KO: error on $1"
      exit
else
      echo "OK: step $1"
fi
}
echo "Empezamos"

function configure {
# configure AWS
mkdir ~/.aws
echo "[default]" >> ~/.aws/config
echo "region = eu-west-1" >> ~/.aws/config
echo "aws_secret_access_key = $VAR_ACC"  >> ~/.aws/config
echo "aws_access_key_id = $VAR_KEY" >> ~/.aws/config

aws s3 ls
err_ "aws cli configure"
}

function inicial {
# launch terraform
cd /opt/src/examen
zip -r ./terraform/lambda/functions/lambda_nodejs.zip lambda_nodejs
err_ "zip script"

cd /opt/src/examen/terraform
terraform init
err_ "terraform init"
echo "terraform plan -out ./tf.plan.output"
err_ "terraform plan"
echo "terraform apply ./tf.apply.output"
err_ "terraform init"
}

function carga {
  # change files on S3
  curl -o files/$1.json http://www.omdbapi.com/?apikey=$VAR_API&t=$1
  aws s3 cp /files/$1.json s3://$bucket/
}

case $VAR_OP in
  inicial)
       configure
       inicial
  ;;
  carga)
      configure
      for i in $(cat ./$lt2 )
      do
        carga $1
      done
  ;;
  *)
      echo "No está cargada la variable VAR_OP"
      exit
  ;;
esac
