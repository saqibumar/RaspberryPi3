# RaspberryPi3
Raspberry pi docker setup

```
docker build --target development --no-cache -t rpi3-app:development .
```
To run the container run

```
docker run --rm \
    -it \
   -p 8080:8080 -p 8000:8000 \
    --volume ${PWD}:/app \
    --name rpi3-app-develop \
    rpi3-app:development manual
```

```
docker run -it -p 8080:8080 -p 8000:8000 --volume ${PWD}:/app --name rpi3-app-develop rpi3-app:development manual
```

```
FOR nginx
docker run --name rpi3-nginx1 -d -p 8080:80 rpi3-nginx
```