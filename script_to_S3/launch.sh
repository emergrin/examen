#!/bin/bash

option=$OP

function err_ {
if [ $? != 0 ]; then
      echo "KO: error on $1"
      exit
else
      echo "OK: step $1"
fi
}
echo uno
function inicial {
# configure AWS
echo "[default]" >> ~/.aws/config
echo "region = eu-west-1" >> ~/.aws/config
echo "aws_secret_access_key = $1"  >> ~/.aws/config
echo "aws_access_key_id = $2" >> ~/.aws/config

aws s3 ls
err_ "aws cli configure"

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
  curl -o files/$1.json http://www.omdbapi.com/?apikey=3e721637&t=$1
}

case $option in
  inicial)
       inicial $aws_access $aws_secret
  ;;
  carga)
       carga
  ;;
  *)
       exit
  ;;
esac
