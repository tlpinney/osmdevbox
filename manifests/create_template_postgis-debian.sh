#!/bin/bash

# Modified from
# https://docs.djangoproject.com/en/dev/_downloads/create_template_postgis-debian.sh
# had to add -T template0 because of a UTF8 problem...


# For Ubuntu 10.10 (with PostGIS 1.5)
POSTGIS_SQL_PATH=/usr/share/postgresql/8.4/contrib/postgis-1.5
POSTGIS_SQL=postgis.sql


createdb -E UTF8 template_postgis -T template0 && \
createlang -d template_postgis plpgsql && \
psql -d postgres -c "UPDATE pg_database SET datistemplate='true' WHERE datname='template_postgis';" && \
psql -d template_postgis -f $POSTGIS_SQL_PATH/$POSTGIS_SQL && \
psql -d template_postgis -f $POSTGIS_SQL_PATH/spatial_ref_sys.sql && \
psql -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;" && \
psql -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"
psql -d template_postgis -c "GRANT ALL ON geography_columns TO PUBLIC;"
