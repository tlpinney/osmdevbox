
# this runs as the postgres user 

createuser openstreetmap -s 
createdb -E UTF8 -O openstreetmap openstreetmap -T template0
createdb -E UTF8 -O openstreetmap osm_test -T template0
createdb -E UTF8 -O openstreetmap osm -T template0
psql -d openstreetmap < /usr/share/pgsql/contrib/btree_gist.sql
echo "alter role openstreetmap password 'openstreetmap'" | psql


# hack to run without a password
createuser vagrant -s 


touch /var/lib/pgsql/database_setup.log




