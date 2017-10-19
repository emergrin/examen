# Terraform Version
Terraform v0.9.11

# NodeJS Version
NodeJS 6.11.
NPM 5.3.0

# Procedure

1.- create a local docker image

```bash
docker build -t examen:test github.com/emergrin/examen.git
```
2.- launch docker image

a) If you need create the infraestructure use this option

```bash
docker run --name base -t -d -e VAR_OP=inicial -e VAR_ACC=XXX -e VAR_KEY=YYY examen:test
```


b) If you only need upload files to process use this option

```bash
docker run --name base -t -d -e VAR_OP=carga -e VAR_ACC=XXX -e VAR_KEY=YYY examen:test
```
