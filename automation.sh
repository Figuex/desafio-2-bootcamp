#!/bin/bash
#Script automation build docker
#Autor: Jose Figueroa 
#read BUILD

while [ $# -gt 0 ];do
    case $1 in
    '--env')
        shift
        [ $# -gt 0 ] && ENV=$1
        ;;
    esac

BUILD=$1
TEMP=./tempdir

if [ -d $TEMP ]
then
echo "Si el directorio ./tempdir existe no crear"
rm -rf  $TEMP
else [ ! -d $TEMP ]
echo "Si el directorio ./tempdir no existe, por favor crear"
mkdir  $TEMP
fi

mkdir -p  $TEMP/templates
mkdir -p  $TEMP/static

cp  desafio2_app.py $TEMP
cp -r templates/*   $TEMP/templates/
cp -r static/*      $TEMP/static/



echo "FROM python:3.11.0a6-slim-buster" >> $TEMP/Dockerfile        
echo "RUN pip install flask" >> $TEMP/Dockerfile                   
echo "COPY ./static /home/myapp/static/" >> $TEMP/Dockerfile       
echo "COPY ./templates /home/myapp/templates/" >> $TEMP/Dockerfile
echo "COPY desafio2_app.py  /home/myapp/" >> $TEMP/Dockerfile      
echo "EXPOSE 5050" >> $TEMP/Dockerfile                             
echo "CMD python3 /home/myapp/desafio2_app.py " >> $TEMP/Dockerfile



echo "#### BUILD Docker #######"
cd $TEMP
docker build -t $BUILD . 

echo "### START CONTAINER###"
docker run -t -d -p 5050:5050 --name $BUILD $BUILD  

echo "###STATUS CONTAINER####"
docker ps -a

break

done
