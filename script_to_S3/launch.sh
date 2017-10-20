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
zip -r ./examen/terraform/lambda/functions/lambda_nodejs.zip ./examen/lambda_nodejs
err_ "zip script"

cd /opt/src/examen/terraform
terraform init
err_ "terraform init"
terraform get
err_ "terraform get"
terraform plan >> ./tf.plan.output
err_ "terraform plan"
terraform apply >> ./tf.apply.output
err_ "terraform init"
git add tf.apply.output terraform.tfstate
git commit -m "terraform output"
}

function carga {
  # change files on S3
  while read line
  do
     film=$(echo ${line// /+})
     file=$(echo ${line// /_})
     curl -o files/$file.json http://www.omdbapi.com/?apikey=$VAR_API&t=$film
     aws s3 cp /files/$file.json s3://egimenez-exam-origen/
  done < /opt/src/list.txt
}

case $VAR_OP in
  inicial)
       configure
       inicial
  ;;
  carga)
      configure
      carga
  ;;
  *)
      echo "No está cargada la variable VAR_OP"
      exit
  ;;
esac
