FROM mriedmann/baseimage:0.0.1
MAINTAINER Michael Riedmann <michael_riedmann@live.com>

# Phusion-Baseimage Startup
ENV HOME /root
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
CMD ["/sbin/my_init"]

# Basic Ubuntu-Env
ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8

# Update APT
RUN apt-get update

# Install Basics
RUN apt-get install wget -y

# Install dependencies
RUN apt-get install -y --no-install-recommends postgresql-9.3 postgresql-contrib-9.3

# Access Fix
RUN mkdir /etc/ssl/private-copy; mv /etc/ssl/private/* /etc/ssl/private-copy/; rm -r /etc/ssl/private; mv /etc/ssl/private-copy /etc/ssl/private; chmod -R 0700 /etc/ssl/private; chown -R postgres /etc/ssl/private
 
# Add Config
ADD postgresql.conf /etc/postgresql/9.3/main/postgresql.conf
ADD pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
RUN chown postgres:postgres /etc/postgresql/9.3/main/*.conf
 
# Add service script
RUN mkdir /etc/service/postgresql
ADD postgresql-run.sh /etc/service/postgresql/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Declare volumes
VOLUME ["/var/lib/postgresql"]

# Expose Port
EXPOSE 5432