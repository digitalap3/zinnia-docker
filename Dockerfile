FROM debian:jessie

RUN apt-get update && DEBIAN_FRONTEND=noninteractive\
    && apt-get install -y python vim build-essential python-pip python2.7-dev \
    curl git tar libpq-dev libjpeg-dev zlib1g-dev nginx
    
RUN pip install django==1.9.8 django-mptt django-tagging pillow \
        beautifulsoup4 mots-vides regex django-contrib-comments \
        gunicorn markdown docutils pytz
         
RUN mkdir /srv/logs/ /srv/run \
       && mkdir /home/djangoapp \
       && mkdir /home/djangoapp/static \
       && mkdir /home/djangoapp/media \
       && mkdir /home/djangoapp/templates \
       && mkdir /home/djangoapp/templates/zinnia \
       && rm /etc/nginx/sites-enabled/default
       
COPY zinginx /home/djangoapp
COPY gunicornsock.sh /home/djangoapp 

##COPY consider inserting project folders
## otherwise run startproject and make changes to settings.py etc
##JUST BE SURE PROJECT NAME MATCHES GUNICORN.SH DIRS!!
    
##THIS ALLOWS US TO MAKE PERSISTANT CHANGES TO THE NGINX FILE 
RUN ln -s /home/djangoapp/zinginx /etc/nginx/sites-enabled/zinginx
    
VOLUME /home

RUN apt-get remove --purge -y $BUILD_PACKAGES && rm -rf /var/lib/apt/lists/*\
    && apt-get autoremove

EXPOSE 8000 80

WORKDIR /home/djangoapp

CMD service nginx start && sh gunicornsock.sh

