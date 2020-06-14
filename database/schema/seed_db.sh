#!/usr/bin/env bash

while [ $(cqlsh -e "describe dummy" 2>&1 >/dev/null | grep "Unable to connect" | wc -l) -ge 1 ]; do
  sleep 2;
done

echo 'Cassandra is up!'

if [ ! -f /var/lib/cassandra/.seeded ]; then
    cqlsh < /opt/data/db_schema.cql
    echo 'seeded' > /var/lib/cassandra/.seeded
# else
#     cp -avr /mnt/conf_folder/install/* /mnt/wso2das-3.1.0/
fi;
