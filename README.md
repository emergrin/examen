# Software versions used

## Terraform Version
Terraform v0.9.11

## Docker Version
Docker v17.09.0-ce
Docker-compose v1.11.2

## NodeJS Version
NodeJS 6.11
NPM 5.3.0

# What do you need?

To execute this program, you only need two things:

- Technical resource: bash shell script installed on your PC to launch the deploy script and docker component install in your PC to create a container inside this.
- Accouns: you need a AWS accouts to use the CLI and a OMDB APPi Key to optain the json file.

# Procedure

1. Download the deploy script:
```
wget https://github.com/emergrin/examen/blob/master/deploy.sh
```
2. Make executable the script:
```
chmod +x deploy.sh
```
3. Launch the script and select the correct
```
./deploy.sh
```
If you don't have a valid API Key you can use this list of films

```
Star Wars
Hellboy
Big Trouble in Little China
```
