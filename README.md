#docker-simutrans

An easy way to get a simutrans server up and running using docker.

###How to run ?

```sh
docker run -d -p 13353:13353 -v $(pwd)/pak128:/simutrans/pak -v $(pwd)/save/:/simutrans/save/ -v $(pwd)/simuconf.tab:/simutrans/config/simuconf.tab izissise/simutrans
```
