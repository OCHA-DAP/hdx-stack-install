# copyleft 2015 teodorescu.serban@gmail.com

################################################

varnish:
  image: ${HDX_IMG_BASE}varnish:latest
  hostname: varnish
  restart: always
  ports:
    - "${HDX_WB_ADDR}:${HDX_VARNISH_HTTP_PORT}:80"
  environment:
    - HDX_HTTPS_REDIRECT=off # This will only be useful in BlackMesh prod (or AWS w/ SSL-terminating ELB)
    - HDX_NGINX_HOST=${HDX_WB_ADDR}
    - HDX_NGINX_ADDR=${HDX_WB_ADDR}
    - HDX_NGINX_PORT=${HDX_HTTP_PORT}
    - VIRTUAL_HOST=${HDX_SHORT_PREFIX}.${HDX_DOMAIN},${HDX_PREFIX}docs.${HDX_DOMAIN},${HDX_PREFIX}data.${HDX_DOMAIN},${HDX_PREFIX}manage.${HDX_DOMAIN}

web:
  image: ${HDX_IMG_BASE}nginx:latest
  hostname: nginx
  restart: always
  volumes:
    - "${HDX_VOL_FILES}/www:/srv/www"
    - "${HDX_VOL_LOGS}/nginx:/var/log/nginx"
  ports:
    - "${HDX_WB_ADDR}:${HDX_HTTP_PORT}:80"
    - "${HDX_WB_ADDR}:${HDX_HTTPS_PORT}:443"
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
    - HDX_GISLAYER_ADDR=${HDX_GISLAYER_ADDR}
    - HDX_GISLAYER_PORT=${HDX_GISLAYER_PORT}

################################################

email:
  image: ${HDX_IMG_BASE}email:latest
  hostname: email
  restart: always
  volumes:
    - "${HDX_VOL_LOGS}/email:/var/log/email"
  ports:
    - "${HDX_SMTP_ADDR}:${HDX_SMTP_PORT}:25"
  environment:
    - HDX_DKIM_KEY=${HDX_DKIM_KEY}

################################################

gisapi:
  image: ${HDX_IMG_BASE}gisapi:latest
  hostname: gisapi
  ports:
    - "${HDX_GISAPI_ADDR}:${HDX_GISAPI_PORT}:80"
    - "${HDX_GISAPI_DEBUG_ADDR}:${HDX_GISAPI_DEBUG_PORT}:5858"
  environment:
    - HDX_GISDB_ADDR=${HDX_GISDB_ADDR}
    - HDX_GISDB_PORT=${HDX_GISDB_PORT}

gisredis:
  image: ${HDX_IMG_BASE}redis:latest
  hostname: gisredis
  ports:
    - "${HDX_GISREDIS_ADDR}:${HDX_GISREDIS_PORT}:6379"

gislayer:
  image: ${HDX_IMG_BASE}gislayer:latest
  hostname: gislayer
  ports:
    - "${HDX_GISLAYER_ADDR}:${HDX_GISLAYER_PORT}:5000"
  extra_hosts:
    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  environment:
    - HDX_GISDB_ADDR=${HDX_GISDB_ADDR}
    - HDX_GISDB_PORT=${HDX_GISDB_PORT}
    - HDX_GISDB_DB=${HDX_GISDB_DB}
    - HDX_GISDB_USER=${HDX_GISDB_USER}
    - HDX_GISDB_PASS=${HDX_GISDB_PASS}
    - HDX_GISREDIS_ADDR=${HDX_GISREDIS_ADDR}
    - HDX_GISREDIS_PORT=${HDX_GISREDIS_PORT}
    - HDX_PREFIX=${HDX_PREFIX}
    - HDX_DOMAIN=${HDX_DOMAIN}
    - HDX_GIS_API_KEY=${HDX_GIS_API_KEY}

gisworker:
  image: ${HDX_IMG_BASE}gisworker:latest
  hostname: gisworker
  extra_hosts:
    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  environment:
    - HDX_GISDB_ADDR=${HDX_GISDB_ADDR}
    - HDX_GISDB_PORT=${HDX_GISDB_PORT}
    - HDX_GISDB_DB=${HDX_GISDB_DB}
    - HDX_GISDB_USER=${HDX_GISDB_USER}
    - HDX_GISDB_PASS=${HDX_GISDB_PASS}
    - HDX_GISREDIS_ADDR=${HDX_GISREDIS_ADDR}
    - HDX_GISREDIS_PORT=${HDX_GISREDIS_PORT}
    - HDX_PREFIX=${HDX_PREFIX}
    - HDX_DOMAIN=${HDX_DOMAIN}
    - HDX_GIS_API_KEY=${HDX_GIS_API_KEY}
    - HDX_GIS_TMP=${HDX_GIS_TMP}
#  mem_limit: 1G

gisdb:
  image: ${HDX_IMG_BASE}psql-gis:latest
  hostname: gisdb
  volumes:
    - "${HDX_VOL_DBS}/psql-gis:/srv/db"
    - "${HDX_VOL_LOGS}/gis-psql:/var/log/psql"
  ports:
    - "${HDX_GISDB_ADDR}:${HDX_GISDB_PORT}:5432"

################################################
dataproxy:
  image: ${HDX_IMG_BASE}dataproxy:latest
  hostname: dataproxy
  restart: always
  ports:
    - "${HDX_DATAPROXY_ADDR}:${HDX_DATAPROXY_PORT}:5000"
  extra_hosts:
    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    - "${HDX_PREFIX}manage.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    - "manage.${HDX_DOMAIN}: ${HDX_PROD_CPS_ADDR}"

solr:
  image: ${HDX_IMG_BASE}solr:latest
  hostname: solr
  restart: always
  volumes:
    - "${HDX_VOL_DBS}/solr:/srv/solr/example/solr/ckan/data"
  ports:
    - "${HDX_SOLR_ADDR}:${HDX_SOLR_PORT}:8983"

dbckan:
  image: ${HDX_IMG_BASE}psql-ckan:latest
  hostname: dbckan
  restart: always
  volumes:
    - "${HDX_VOL_DBS}/psql-ckan:/srv/db"
    - "${HDX_VOL_LOGS}/ckan-psql:/var/log/psql"
  ports:
    - "${HDX_CKANDB_ADDR}:${HDX_CKANDB_PORT}:5432"

ckan:
  image: ${HDX_IMG_BASE}ckan:latest
  hostname: ckan
  restart: always
  volumes:
    - "${HDX_VOL_BACKUPS}:/srv/backup"
    - "${HDX_VOL_FILES}/filestore:/srv/filestore"
    - "${HDX_VOL_LOGS}/ckan:/var/log/ckan"
  ports:
    - "${HDX_CKAN_ADDR}:${HDX_CKAN_PORT}:5000"
  extra_hosts:
    - "${HDX_PREFIX}docs.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    - "${HDX_PREFIX}manage.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  environment:
    - HDX_BACKUP_SERVER=${HDX_BACKUP_SERVER}
    - HDX_BACKUP_USER=${HDX_BACKUP_USER}
    - HDX_BACKUP_BASE_DIR=${HDX_BACKUP_BASE_DIR}
    - HDX_BACKUP_DIR=${HDX_BACKUP_DIR}
    - HDX_CKAN_API_KEY=${HDX_CKAN_API_KEY}
    - HDX_CKAN_BRANCH=${HDX_CKAN_BRANCH}
    - HDX_CKAN_RECAPTCHA_KEY=${HDX_CKAN_RECAPTCHA_KEY}
    - HDX_CKANDB_ADDR=${HDX_CKANDB_ADDR}
    - HDX_CKANDB_PORT=${HDX_CKANDB_PORT}
    - HDX_CKANDB_DB=${HDX_CKANDB_DB}
    - HDX_CKANDB_USER=${HDX_CKANDB_USER}
    - HDX_CKANDB_PASS=${HDX_CKANDB_PASS}
    - HDX_CKANDB_USER_DATASTORE=${HDX_CKANDB_USER_DATASTORE}
    - HDX_CKANDB_DB_DATASTORE=${HDX_CKANDB_DB_DATASTORE}
    - HDX_DOMAIN=${HDX_DOMAIN}
    - HDX_FILESTORE=/srv/filestore
    - HDX_GISDB_ADDR=${HDX_GISDB_ADDR}
    - HDX_GISDB_PORT=${HDX_GISDB_PORT}
    - HDX_GISLAYER_ADDR=${HDX_GISLAYER_ADDR}
    - HDX_GISLAYER_PORT=${HDX_GISLAYER_PORT}
    - HDX_PREFIX=${HDX_PREFIX}
    - HDX_SMTP_ADDR=${HDX_SMTP_ADDR}
    - HDX_SMTP_PORT=${HDX_SMTP_PORT}
    - HDX_SOLR_ADDR=${HDX_SOLR_ADDR}
    - HDX_SOLR_PORT=${HDX_SOLR_PORT}
    - HDX_SSH_KEY=${HDX_SSH_KEY}
    - HDX_SSH_PUB=${HDX_SSH_PUB}
    - HDX_TYPE=${HDX_TYPE}

################################################

dbcps:
  image: ${HDX_IMG_BASE}psql-cps:latest
  hostname: dbcps
  restart: always
  volumes:
    - "${HDX_VOL_DBS}/psql-cps:/srv/db"
    - "${HDX_VOL_LOGS}/cps-psql:/var/log/psql"
  ports:
    - "${HDX_CPSDB_ADDR}:${HDX_CPSDB_PORT}:5432"

cps:
  image: ${HDX_IMG_BASE}cps:latest
  hostname: cps
  restart: always
  ports:
    - "${HDX_CPS_ADDR}:${HDX_CPS_PORT}:8080"
  volumes:
    - "${HDX_VOL_BACKUPS}:/srv/backup"
    - "${HDX_VOL_LOGS}/cps:${HDX_FOLDER}/logs"
  extra_hosts:
    - "${HDX_PREFIX}docs.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    - "${HDX_PREFIX}manage.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  environment:
    - HDX_BACKUP_SERVER=${HDX_BACKUP_SERVER}
    - HDX_BACKUP_USER=${HDX_BACKUP_USER}
    - HDX_BACKUP_BASE_DIR=${HDX_BACKUP_BASE_DIR}
    - HDX_BACKUP_DIR=${HDX_BACKUP_DIR}
    - HDX_CKAN_API_KEY=${HDX_CKAN_API_KEY}
    - HDX_CPS_BRANCH=${HDX_CPS_BRANCH}
    - HDX_CPSDB_ADDR=${HDX_CPSDB_ADDR}
    - HDX_CPSDB_PORT=${HDX_CPSDB_PORT}
    - HDX_CPSDB_DB=${HDX_CPSDB_DB}
    - HDX_CPSDB_USER=${HDX_CPSDB_USER}
    - HDX_CPSDB_PASS=${HDX_CPSDB_PASS}
    - HDX_DOMAIN=${HDX_DOMAIN}
    - HDX_FOLDER=${HDX_FOLDER}
    - HDX_PREFIX=${HDX_PREFIX}
    - HDX_SMTP_ADDR=${HDX_SMTP_ADDR}
    - HDX_SMTP_PORT=${HDX_SMTP_PORT}
    - HDX_SSH_KEY=${HDX_SSH_KEY}
    - HDX_SSH_PUB=${HDX_SSH_PUB}
    - HDX_TYPE=${HDX_TYPE}

################################################

dbblog:
  image: ${HDX_IMG_BASE}mysql:latest
  hostname: dbblog
  restart: always
  volumes:
    - "${HDX_VOL_DBS}/mysql:/srv/db"
    - "${HDX_VOL_LOGS}/mysql-blog:${HDX_FOLDER}/mysql"
  ports:
    - "${HDX_BLOGDB_ADDR}:${HDX_BLOGDB_PORT}:3306"

blog:
  image: ${HDX_IMG_BASE}blog:latest
  hostname: blog
  restart: always
  ports:
    - "${HDX_BLOG_ADDR}:${HDX_BLOG_PORT}:9000"
  volumes:
    - "${HDX_VOL_BACKUPS}:/srv/backup"
    - "${HDX_VOL_FILES}/www/docs:/srv/www/docs"
    - "${HDX_VOL_LOGS}/blog:${HDX_FOLDER}/blog"
  extra_hosts:
    - "${HDX_PREFIX}docs.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    - "${HDX_PREFIX}manage.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
#    - "${HDX_BLOGDB_ADDR}: db"
  environment:
    - HDX_BACKUP_SERVER=${HDX_BACKUP_SERVER}
    - HDX_BACKUP_USER=${HDX_BACKUP_USER}
    - HDX_BACKUP_BASE_DIR=${HDX_BACKUP_BASE_DIR}
    - HDX_BACKUP_DIR=${HDX_BACKUP_DIR}
    - HDX_BLOG_DIR=${HDX_BLOG_DIR}
    - HDX_BLOGDB_ADDR=${HDX_BLOGDB_ADDR}
    - HDX_BLOGDB_PORT=${HDX_BLOGDB_PORT}
    - HDX_BLOGDB_DB=${HDX_BLOGDB_DB}
    - HDX_BLOGDB_USER=${HDX_BLOGDB_USER}
    - HDX_BLOGDB_PASS=${HDX_BLOGDB_PASS}
    - HDX_DOMAIN=${HDX_DOMAIN}
    - HDX_PREFIX=${HDX_PREFIX}
    - HDX_SSH_KEY=${HDX_SSH_KEY}
    - HDX_SSH_PUB=${HDX_SSH_PUB}

################################################
util:
  image: ${HDX_IMG_BASE}util:latest
  hostname: utility
#  restart: always
  volumes:
    - "${HDX_VOL_BACKUPS}:/srv/backup"
    - "${HDX_VOL_FILES}:/srv/files"
    - "${HDX_VOL_LOGS}:/srv/logs"
  extra_hosts:
    - "${HDX_PREFIX}docs.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    - "${HDX_PREFIX}manage.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  environment:
    - HDX_BACKUP_BASE_DIR=${HDX_BACKUP_BASE_DIR}
    - HDX_BACKUP_SERVER=${HDX_BACKUP_SERVER}
    - HDX_BACKUP_USER=${HDX_BACKUP_USER}
    - HDX_BACKUP_DIR=${HDX_BACKUP_DIR}
    - HDX_BASE_VOL_PATH=${HDX_BASE_VOL_PATH}
    - HDX_BLOG_ADDR=${HDX_BLOG_ADDR}
    - HDX_BLOGDB_ADDR=${HDX_BLOGDB_ADDR}
    - HDX_BLOGDB_DB=${HDX_BLOGDB_DB}
    - HDX_BLOGDB_PASS=${HDX_BLOGDB_PASS}
    - HDX_BLOGDB_PORT=${HDX_BLOGDB_PORT}
    - HDX_BLOGDB_USER=${HDX_BLOGDB_USER}
    - HDX_BLOG_PORT=${HDX_BLOG_PORT}
    - HDX_BLOG_DIR=${HDX_BLOG_DIR}
    - HDX_CKAN_ADDR=${HDX_CKAN_ADDR}
    - HDX_CKAN_API_KEY=${HDX_CKAN_API_KEY}
    - HDX_CKAN_BRANCH=${HDX_CKAN_BRANCH}
    - HDX_CKANDB_ADDR=${HDX_CKANDB_ADDR}
    - HDX_CKANDB_PORT=${HDX_CKANDB_PORT}
    - HDX_CKANDB_DB=${HDX_CKANDB_DB}
    - HDX_CKANDB_USER=${HDX_CKANDB_USER}
    - HDX_CKANDB_PASS=${HDX_CKANDB_PASS}
    - HDX_CKANDB_USER_DATASTORE=${HDX_CKANDB_USER_DATASTORE}
    - HDX_CKANDB_DB_DATASTORE=${HDX_CKANDB_DB_DATASTORE}
    - HDX_CKAN_PORT=${HDX_CKAN_PORT}
    - HDX_CKAN_RECAPTCHA_KEY=${HDX_CKAN_RECAPTCHA_KEY}
    - HDX_CPS_ADDR=${HDX_CPS_ADDR}
    - HDX_CPS_BRANCH=${HDX_CPS_BRANCH}
    - HDX_CPSDB_ADDR=${HDX_CPSDB_ADDR}
    - HDX_CPSDB_PORT=${HDX_CPSDB_PORT}
    - HDX_CPSDB_DB=${HDX_CPSDB_DB}
    - HDX_CPSDB_USER=${HDX_CPSDB_USER}
    - HDX_CPSDB_PASS=${HDX_CPSDB_PASS}
    - HDX_CPS_PORT=${HDX_CPS_PORT}
    - HDX_DATAPROXY_ADDR=${HDX_DATAPROXY_ADDR}
    - HDX_DATAPROXY_PORT=${HDX_DATAPROXY_PORT}
    - HDX_DB_ADDR=${HDX_DB_ADDR}
    - HDX_DKIM_KEY=${HDX_DKIM_KEY}
    - HDX_DOCKER_ADDR=${HDX_DOCKER_ADDR}
    - HDX_DOMAIN=${HDX_DOMAIN}
    - HDX_FOLDER=${HDX_FOLDER}
    - HDX_GISAPI_ADDR=${HDX_GISAPI_ADDR}
    - HDX_GISAPI_DEBUG_ADDR=${HDX_GISAPI_DEBUG_ADDR}
    - HDX_GISAPI_DEBUG_PORT=${HDX_GISAPI_DEBUG_PORT}
    - HDX_GIS_API_KEY=${HDX_GIS_API_KEY}
    - HDX_GISAPI_PORT=${HDX_GISAPI_PORT}
    - HDX_GISDB_ADDR=${HDX_GISDB_ADDR}
    - HDX_GISDB_PORT=${HDX_GISDB_PORT}
    - HDX_GISLAYER_ADDR=${HDX_GISLAYER_ADDR}
    - HDX_GISLAYER_PORT=${HDX_GISLAYER_PORT}
    - HDX_GISREDIS_ADDR=${HDX_GISREDIS_ADDR}
    - HDX_GISREDIS_PORT=${HDX_GISREDIS_PORT}
    - HDX_HTTP_PORT=${HDX_HTTP_PORT}
    - HDX_HTTPS_PORT=${HDX_HTTPS_PORT}
    - HDX_IMG_BASE=${HDX_IMG_BASE}
    - HDX_MP_ADDR=${HDX_MP_ADDR}
    - HDX_NGINX_PASS=${HDX_NGINX_PASS}
    - HDX_PREFIX=${HDX_PREFIX}
    - HDX_PROD_CPS_ADDR=${HDX_PROD_CPS_ADDR}
    - HDX_SHORT_PREFIX=${HDX_SHORT_PREFIX}
    - HDX_SMTP_ADDR=${HDX_SMTP_ADDR}
    - HDX_SMTP_PORT=${HDX_SMTP_PORT}
    - HDX_SOLR_ADDR=${HDX_SOLR_ADDR}
    - HDX_SOLR_PORT=${HDX_SOLR_PORT}
    - HDX_SSH_KEY=${HDX_SSH_KEY}
    - HDX_SSH_PUB=${HDX_SSH_PUB}
    - HDX_SSL_KEY=${HDX_SSL_KEY}
    - HDX_TYPE=${HDX_TYPE}
    - HDX_USER_AGENT=${HDX_USER_AGENT}
    - HDX_VARNISH_HTTP_PORT=${HDX_VARNISH_HTTP_PORT}
    - HDX_WB_ADDR=${HDX_WB_ADDR}
