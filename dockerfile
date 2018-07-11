FROM gcr.io/dropviz-181317/dropviz-shiny-server
ARG BRANCH=master
MAINTAINER dkulp@broadinstitute.org
RUN rm -r /srv/shiny-server
WORKDIR /srv/shiny-server

RUN git clone https://github.com/broadinstitute/dropviz.git .
RUN git checkout $BRANCH
RUN mkdir -p www/cache/metacells

RUN chmod -R a+rwx www

RUN mkdir -p www/cache/ic
COPY ic/* www/cache/ic/

RUN echo "dropviz-bookmarks /var/lib/shiny-server/bookmarks/ gcsfuse rw,uid=999,gid=999" >> /etc/fstab
COPY image/shiny-server.sh /bin
RUN chmod +x /bin/shiny-server.sh
CMD /bin/shiny-server.sh

EXPOSE 80

# debug:
RUN echo "preserve_logs true;" >> /etc/shiny-server/shiny-server.conf

# start image with full privs on GCE console and these mount points
#docker run -d --privileged
#              -v /mnt/disks/dropseq/staged/:/cache/ 
#              -v /mnt/disks/dropseq/atlas_ica/:/atlas_ica/ 