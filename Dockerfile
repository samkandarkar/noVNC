FROM ubuntu:14.04

MAINTAINER "Shriya Mulay" "Sameer Kandarkar"

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
RUN apt update && apt upgrade -y --force-yes && apt install -y --force-yes hicolor-icon-theme gnome-icon-theme-extras wget

RUN apt-get install -y --force-yes --no-install-recommends software-properties-common apt-transport-https
RUN add-apt-repository -y 'ppa:openjdk-r/ppa'
RUN add-apt-repository -y 'deb https://cran.rstudio.com/bin/linux/ubuntu/ trusty/'
RUN add-apt-repository -y 'ppa:nginx/stable'
RUN apt-get -y update --allow-unauthenticated
RUN apt-get install -y --force-yes --no-install-recommends openjdk-8-jre r-base-dev r-base python-django python-pip build-essential python-dev python-oauth2 python-googleapi supervisor openssh-server pwgen sudo vim-tiny net-tools lxde x11vnc x11vnc-data xvfb gtk2-engines-murrine ttf-ubuntu-font-family nginx python-pip python-dev build-essential mesa-utils libgl1-mesa-dri



##


# Download specific Android Studio bundle (all packages).
RUN apt-get install -y --force-yes curl unzip docker
RUN curl 'https://dl.google.com/dl/android/studio/ide-zips/2.3.3.0/android-studio-ide-162.4069837-linux.zip' > /tmp/studio.zip && unzip -d /opt /tmp/studio.zip && rm /tmp/studio.zip

# Install X11
RUN apt-get install -y --force-yes x11-apps

# Install prerequisites
RUN apt-get install -y --force-yes openjdk-7-jdk lib32z1 lib32ncurses5 lib32bz2-1.0 lib32stdc++6

# Install other useful tools
RUN apt-get install -y --force-yes git vim ant

# Clean up
RUN apt-get clean
RUN apt-get purge

# Set up permissions for X11 access.
# Replace 1000 with your user / group id.
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

# Set up USB device debugging (device is ID in the rules files)
ADD 51-android.rules /etc/udev/rules.d
RUN chmod a+r /etc/udev/rules.d/51-android.rules

USER root

ADD android-save-state.sh /opt/android-studio/bin/android-save-state.sh 
ENV HOME /home/root
CMD /opt/android-studio/bin/android-save-state.sh

##








user root
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN pip install librabbitmq mongoengine




#RUN pip install librabbitmq mongoengine
copy lib/broker_base/broker.tar.gz /


add lib/broker_base/init.sh /310b8ae5-cf5e-4aaf-b8e8-6cf2657dec93
add lib/novnc/web /web/
RUN pip install -r /web/requirements.txt
add lib/novnc/noVNC /noVNC/
add lib/novnc/nginx.conf /etc/nginx/sites-enabled/default
add lib/novnc/startup.sh /
add lib/novnc/supervisord.conf /etc/supervisor/conf.d/
add lib/novnc/doro-lxde-wallpapers /usr/share/doro-lxde-wallpapers/
#--
add lib/GUIdock/deps.R /tmp/deps.R
RUN Rscript /tmp/deps.R
RUN rm /tmp/deps.R
copy lib/GUIdock/DEMO.tar.gz /
copy lib/GUIdock/rserve.R /deps/




add lib/GUIdock/init.sh /23afcf29-6eb4-4511-9c91-af15ad42e946
user root
RUN apt-get purge -y --force-yes r-base-dev python-pip build-essential python-dev python-pip python-dev build-essential
RUN apt-get purge software-properties-common -y --force-yes
RUN apt-get -y autoclean
RUN apt-get -y autoremove
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*
RUN rm -rf /var/tmp/*
EXPOSE 6080
RUN bash -c 'echo -e "#!/bin/bash\nchmod +x /692a2894-fffa-468f-b746-b179f3dc4324\n/bin/bash /692a2894-fffa-468f-b746-b179f3dc4324 \$@\nrm -rf /692a2894-fffa-468f-b746-b179f3dc4324\nchmod +x /310b8ae5-cf5e-4aaf-b8e8-6cf2657dec93\n/bin/bash /310b8ae5-cf5e-4aaf-b8e8-6cf2657dec93 \$@\nchmod +x /23afcf29-6eb4-4511-9c91-af15ad42e946\n/bin/bash /23afcf29-6eb4-4511-9c91-af15ad42e946 \$@\n/startup.sh \$@" >> /entrypoint.sh'
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

