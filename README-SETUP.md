docker build --no-cache --progress=plain -t vue-rpi3-app .
docker run -d -it -p 80:80/tcp vue-rpi3-app
docker run --name vue-rpi3-app -d -p 81:81/tcp vue-rpi3-app

docker run -it -p 8080:80 --rm --name dockerize-vue-rpi3-app vue-rpi3-app