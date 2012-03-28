# the openstreetmap rails app requires a directory for GPX traces and rendered images
# this creates those directories and corrects the config to point to those directories
mkdir -p /home/vagrant/osm/images
mkdir -p /home/vagrant/osm/traces

sed -i 's/dir: \"\/home\/osm\//dir: \"\/home\/vagrant\/osm\//' /home/vagrant/openstreetmap-website/config/application.yml