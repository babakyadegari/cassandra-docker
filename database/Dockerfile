FROM cassandra:latest AS cassandra-base

RUN mkdir -p /opt/data/

COPY ./schema/db_schema.cql /opt/data/db_schema.cql

#RUN sed -i 's/exec \"\$\@\"/\/seed_db.sh\&\nexec \"\$\@\"/' docker-entrypoint.sh
#RUN sed -i 's/exec \"\$\@\"/echo \"\$\@\"\nexec \"\$\@\"/' docker-entrypoint.sh

#COPY ./schema/db_schema.cql /docker-entrypoint-initdb.d/

COPY ./schema/seed_db.sh /seed_db.sh
RUN chmod +x /seed_db.sh

VOLUME ["/var/lib/cassandra"]

EXPOSE 9042 7000 7001 7199

#ENTRYPOINT ["/docker-entrypoint.sh"]

#CMD ["/bin/bash", "/seed_db.sh"]
