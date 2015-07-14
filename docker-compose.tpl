# copyleft 2015 teodorescu.serban@gmail.com

################################################

varnish:
  image: ${HDX_IMG_BASE}varnish:latest
  hostname: varnish
  restart: always
  ports:
    - "${HDX_VARNISH_HTTP_PORT}:80"
  links:
    - "web:web"
  environment:
    - HDX_HTTPS_REDIRECT=off # This will only be useful in BlackMesh prod (or AWS w/ SSL-terminating ELB)

web:
  image: ${HDX_IMG_BASE}nginx:latest
  hostname: nginx
  restart: always
  volumes:
     - "${HDX_BASE_VOL_PATH}/www:/srv/www"
     - "${HDX_BASE_VOL_PATH}/log/nginx:/var/log/nginx"
  ports:
    - "${HDX_HTTP_PORT}:80"
    - "${HDX_HTTPS_PORT}:443"
  environment:
    - HDX_DOMAIN=${HDX_DOMAIN}
    - HDX_PREFIX=${HDX_PREFIX}
    - HDX_SSL_KEY=${HDX_SSL_KEY}
    - HDX_TYPE=${HDX_TYPE}
    - HDX_NGINX_PASS=${HDX_NGINX_PASS}
    - HDX_BLOG_ADDR=${HDX_BLOG_ADDR}
    - HDX_BLOG_PORT=${HDX_BLOG_PORT}
    - HDX_CKAN_ADDR=${HDX_CKAN_ADDR}
    - HDX_CKAN_PORT=${HDX_CKAN_PORT}
    - HDX_CPS_ADDR=${HDX_CPS_ADDR}
    - HDX_CPS_PORT=${HDX_CPS_PORT}
    - HDX_DATAPROXY_ADDR=${HDX_DATAPROXY_ADDR}
    - HDX_DATAPROXY_PORT=${HDX_DATAPROXY_PORT}
    - HDX_GISAPI_ADDR=${HDX_GISAPI_ADDR}
    - HDX_GISAPI_PORT=${HDX_GISAPI_PORT}
#    - HDX_OGRE_ADDR=${HDX_OGRE_ADDR}
#    - HDX_OGRE_PORT=${HDX_OGRE_PORT}

################################################

email:
  image: ${HDX_IMG_BASE}email:latest
  hostname: email
  restart: always
  volumes:
     - "${HDX_BASE_VOL_PATH}/log/email:/var/log/email"
  ports:
    - "${HDX_SMTP_ADDR}:${HDX_SMTP_PORT}:25"
  environment:
    - HDX_DKIM_KEY=${HDX_DKIM_KEY}

################################################

gisapi:
  image: ${HDX_IMG_BASE}api:latest
  hostname: gisapi
  ports:
    - "${HDX_GISAPI_ADDR}:${HDX_GISAPI_PORT}:80"
    - "${HDX_GISAPI_DEBUG_ADDR}:${HDX_GISAPI_DEBUG_PORT}:5858"
  links:
    - "gisdb:db"

gisredis:
  image: ${HDX_IMG_BASE}redis:latest
  hostname: gisredis
#  ports:
#    - "${HDX_GISREDIS_ADDR}:${HDX_GIREDIS_PORT}:6379"


gislayer:
  image: ${HDX_IMG_BASE}gislayer:latest
  hostname: gislayer
  ports:
    - "${HDX_GISLAYER_ADDR}:${HDX_GISLAYER_PORT}:5000"
  links:
    - "gisdb:db"
    - "gisredis:redis"
  environment:
    - HDX_CKAN_ADDR=${HDX_CKAN_ADDR}
    - HDX_CKAN_PORT=${HDX_CKAN_PORT}
    - HDX_GISAPI_ADDR=${HDX_GISAPI_ADDR}
    - HDX_GISAPI_PORT=${HDX_GISAPI_PORT}
    - HDX_GIS_API_KEY=${HDX_GIS_API_KEY}

gisdb:
  image: ${HDX_IMG_BASE}psql-gis:latest
  hostname: gisdb

################################################
dataproxy:
  image: ${HDX_IMG_BASE}dataproxy:latest
  hostname: dataproxy
  restart: always
  ports:
    - "${HDX_DATAPROXY_ADDR}:${HDX_DATAPROXY_PORT}:9223"

#ogre:
#  image: ${HDX_IMG_BASE}ogre:latest
#  hostname: ogre
#  restart: always
#  ports:
#    - "${HDX_OGRE_ADDR}:${HDX_OGRE_PORT}:3000"

solr:
  image: ${HDX_IMG_BASE}solr:latest
  hostname: solr
  restart: always
  volumes:
    - "${HDX_BASE_VOL_PATH}/solr:/srv/solr/example/solr/ckan/data"

dbckan:
  image: ${HDX_IMG_BASE}psql-ckan:latest
  hostname: dbckan
  restart: always
  volumes:
    - "${HDX_BASE_VOL_PATH}/psql-ckan:/srv/db"
    - "${HDX_BASE_VOL_PATH}/log/cps-psql:/var/log/psql"

ckan:
  image: ${HDX_IMG_BASE}ckan:latest
  hostname: ckan
  restart: always
  links:
    - dbckan:db
    - solr
  volumes:
    - "${HDX_BASE_VOL_PATH}/backup:/srv/backup"
    - "${HDX_BASE_VOL_PATH}/filestore:/srv/filestore"
    - "${HDX_BASE_VOL_PATH}/log/ckan:/var/log/ckan"
  ports:
    - "${HDX_CKAN_ADDR}:${HDX_CKAN_PORT}:9221"
  environment:
    - HDX_CKAN_BRANCH=${HDX_CKAN_BRANCH}
    - HDX_TYPE=${HDX_TYPE}
    - HDX_DOMAIN=${HDX_DOMAIN}
    - HDX_PREFIX=${HDX_PREFIX}
    - HDX_FILESTORE=/srv/filestore
    - HDX_SMTP_ADDR=${HDX_SMTP_ADDR}
    - HDX_SMTP_PORT=${HDX_SMTP_PORT}
    - HDX_GISLAYER_ADDR=${HDX_GISLAYER_ADDR}
    - HDX_GISLAYER_PORT=${HDX_GISLAYER_PORT}
    - HDX_CKAN_RECAPTCHA_KEY=${HDX_CKAN_RECAPTCHA_KEY}
    - HDX_BACKUP_SERVER=${HDX_BACKUP_SERVER}
    - HDX_BACKUP_USER=${HDX_BACKUP_USER}
    - HDX_BACKUP_BASE_DIR=${HDX_BACKUP_BASE_DIR}
    - HDX_SSH_KEY=${HDX_SSH_KEY}
    - HDX_SSH_PUB=${HDX_SSH_PUB}
################################################

dbcps:
  image: ${HDX_IMG_BASE}psql-cps:latest
  hostname: dbcps
  restart: always
  volumes:
    - "${HDX_BASE_VOL_PATH}/psql-cps:/srv/db"
    - "${HDX_BASE_VOL_PATH}/log/cps-psql:/var/log/psql"

cps:
  image: ${HDX_IMG_BASE}cps:latest
  hostname: cps
  restart: always
  links:
    - dbcps:db
  ports:
    - "${HDX_CPS_ADDR}:${HDX_CPS_PORT}:8080"
  volumes:
    - "${HDX_BASE_VOL_PATH}/backup:/srv/backup"
    - "${HDX_BASE_VOL_PATH}/log/cps:${HDX_FOLDER}/logs"
  environment:
    - HDX_CPS_BRANCH=${HDX_CPS_BRANCH}
    - HDX_TYPE=${HDX_TYPE}
    - HDX_DOMAIN=${HDX_DOMAIN}
    - HDX_PREFIX=${HDX_PREFIX}
    - HDX_FOLDER=${HDX_FOLDER}
    - HDX_CKAN_API_KEY=${HDX_CKAN_API_KEY}
    - HDX_BACKUP_SERVER=${HDX_BACKUP_SERVER}
    - HDX_BACKUP_USER=${HDX_BACKUP_USER}
    - HDX_BACKUP_BASE_DIR=${HDX_BACKUP_BASE_DIR}
    - HDX_SSH_KEY=${HDX_SSH_KEY}
    - HDX_SSH_PUB=${HDX_SSH_PUB}

################################################

dbblog:
  image: ${HDX_IMG_BASE}mysql:latest
  hostname: dbblog
  restart: always
  volumes:
    - "${HDX_BASE_VOL_PATH}/mysql:/srv/db"
    - "${HDX_BASE_VOL_PATH}/log/mysql-blog:${HDX_FOLDER}/mysql"

blog:
  image: ${HDX_IMG_BASE}blog:latest
  hostname: blog
  restart: always
  links:
    - dbblog:db
  ports:
    - "${HDX_BLOG_ADDR}:${HDX_BLOG_PORT}:9000"
  volumes:
    - "${HDX_BASE_VOL_PATH}/backup:/srv/backup"
    - "${HDX_BASE_VOL_PATH}/www/docs:/srv/www/docs"
    - "${HDX_BASE_VOL_PATH}/log/blog:${HDX_FOLDER}/blog"
  environment:
    - HDX_DOMAIN=${HDX_DOMAIN}
    - HDX_PREFIX=${HDX_PREFIX}
    - HDX_BACKUP_SERVER=${HDX_BACKUP_SERVER}
    - HDX_BACKUP_USER=${HDX_BACKUP_USER}
    - HDX_BACKUP_BASE_DIR=${HDX_BACKUP_BASE_DIR}
    - HDX_SSH_KEY=${HDX_SSH_KEY}
    - HDX_SSH_PUB=${HDX_SSH_PUB}

################################################
