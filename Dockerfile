FROM phusion/passenger-ruby21:0.9.14
MAINTAINER Michael Ries <michael@riesd.com>

# Setup Nginx
ADD config/nginx.site.conf /etc/nginx/sites-enabled/default
RUN  rm -f /etc/service/nginx/down && apt-get update && apt-get install libsqlite3-dev && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Prod Mode
ADD . /home/app/golf
RUN chown app:app -R /home/app
VOLUME /home/app/golf/db

WORKDIR /home/app/golf
USER root
RUN bundle install

CMD /sbin/my_init
