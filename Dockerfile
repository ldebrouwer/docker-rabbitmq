# docker-rabbitmq
#
# VERSION 0.1

FROM centos
MAINTAINER Dave Goehrig dave@dloh.org

# We need the developer tools to build the occasional add on or two
RUN yum -y groupinstall "Development Tools"

# Install EPEL6 for additional packages
RUN yum -y install http://mirror.pnl.gov/epel/6/i386/epel-release-6-8.noarch.rpm

# install rabbitmq-server 3.1.5
RUN yum -y install http://www.rabbitmq.com/releases/rabbitmq-server/v3.1.5/rabbitmq-server-3.1.5-1.noarch.rpm

# activate plugins
RUN /usr/sbin/rabbitmq-plugins enable rabbitmq_mqtt rabbitmq_stomp rabbitmq_management  rabbitmq_management_agent rabbitmq_management_visualiser rabbitmq_federation rabbitmq_federation_management sockjs

# replace erlang cookie and make sure both root and rabbitmq use it
RUN uuidgen -r | sed 's%-%%g' > ~/.erlang.cookie
RUN cat ~/.erlang.cookie > /var/lib/rabbitmq/.erlang.cookie

# install a custom rabbitmq-server that uses CONTAINER_SERVER as an env var
RUN curl -L https://raw.github.com/cthulhuology/docker-rabbitmq/master/rabbitmq-server > /usr/lib/rabbitmq/bin/rabbitmq-server

# expose AMQP port and Management interface and the epmd port, and the inet_dist_listen_min through inet_dist_listen_max ranges
EXPOSE 5672
EXPOSE 15672
EXPOSE 4369
EXPOSE 9100
EXPOSE 9101
EXPOSE 9102
EXPOSE 9103
EXPOSE 9104
EXPOSE 9105

#CMD /etc/init.d/rabbitmq-server start && /bin/bash -l
CMD /bin/bash -l
