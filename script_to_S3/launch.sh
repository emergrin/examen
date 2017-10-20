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
     curl -o files/$line.json http://www.omdbapi.com/?apikey=$VAR_API&t=$line
     aws s3 cp /files/$line.json s3://$bucket/
     a=$(echo "$line" | cut -d "\"" -s -f 2)
     b=$(echo "$line" | cut -d "\"" -s -f 1 | cut -d " " -s -f 4,5,6,7,8 | cut -d ":" -f 1 | cut -d "K" -f 2 | cut -d "M" -f 2 | cut -d "-" -f 1,2,3)
     echo "$a;$b" >> RRHH
  done < caca
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
