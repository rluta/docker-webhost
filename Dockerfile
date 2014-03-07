FROM ubuntu
MAINTAINER Raphaël Luta <raphael.luta@gmail.com>

# Update the system image and core utilities
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y curl wget python-software-properties
RUN apt-get upgrade -y

# Install apache2 and modules
RUN apt-get install -y apache2 apache2-mpm-worker libapache2-mod-macro
RUN wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-beta_current_amd64.deb
RUN dpkg -i mod-pagespeed*.deb
RUN wget https://dl-ssl.google.com/dl/linux/direct/mod-spdy-beta_current_amd64.deb
RUN dpkg -i mod-spdy*.deb
RUN apt-get -f install
RUN rm *deb
RUN mkdir -p /var/cache/mod_pagespeed
RUN chown -R www-data:www-data /var/cache/mod_pagespeed

# Activate needed modules 
RUN a2enmod expires pagespeed spdy ssl rewrite headers macro

# Add custom macros definitions and add custom VHost files
ADD macros.conf /etc/apache2/conf.d/macros.conf
ADD default /etc/apache2/sites-available/default
ADD default-ssl /etc/apache2/sites-available/default-ssl
ADD a2ensite default default-ssl

# Add config file to auto-start apache2 when starting bash
ADD bash.bashrc /etc/bash.bashrc

# Define volume mount points for the site data and log data
VOLUME ['/var/log/apache2','/var/www']

# Expose HTTP and HTTPS service
EXPOSE 80 443

# Default cmd
CMD ["/bin/bash"]
