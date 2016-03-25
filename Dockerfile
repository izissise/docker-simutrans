# Simutrans server
# Name the maps servergame.sve and put it in ./save
# Launch like this:
# docker run -d -p 13353:13353 -v $(pwd)/pak128:/simutrans/pak -v $(pwd)/save/:/simutrans/save/ -v $(pwd)/simuconf.tab:/simutrans/config/simuconf.tab izissise/simutrans

FROM ubuntu
MAINTAINER izissise <morisset.hugues@gmail.com>

#Create a user for simutrans
RUN mkdir /home/app && groupadd -r app && useradd -d /home/app -r -g app app && chown app:app -R /home/app

RUN apt-get -y update && \
    apt-get -y install build-essential subversion autoconf curl unzip && \
    apt-get -y build-dep simutrans && \
    apt-get -y remove libsdl1.2-dev && \
    rm -rf /var/lib/apt/lists/*

#Use revision 7753
RUN svn export --username=anon --password='' svn://tron.yamagi.org/simutrans@7753

RUN cd /simutrans/simutrans/trunk && ./get_lang_files.sh && \
    autoconf && ./configure --prefix=/usr --enable-server && \
    make && \
    mv simutrans /home/app/ && mv sim /home/app/simutrans/

RUN chown app:app -R /home/app/simutrans
    
#Cleanup
RUN rm -fr /simutrans && cd /home/app/simutrans/ && rm -fr config/simuconf.tab music/ script/
RUN mv /home/app/simutrans /simutrans
RUN strip /simutrans/sim
RUN apt-get -y remove build-essential subversion autoconf

WORKDIR /simutrans
USER app

VOLUME ["/simutrans/pak", "/simutrans/config/simuconf.tab", "/simutrans/save/"]

CMD ["./sim", "-singleuser", "-lang", "en", "-objects", "pak/", "-server", "13353", "-nosound", "-nomidi", "-noaddons", "-log", "1", "-debug", "3", "-load", "servergame.sve"]
