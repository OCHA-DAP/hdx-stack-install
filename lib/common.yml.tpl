# copyleft 2015 teodorescu.serban@gmail.com

################################################

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
  env_file:
    - ./envs/.env_common
    - ./envs/.env_web
    - ./envs/.env_web_private
    - ./envs/.env_blog
    - ./envs/.env_ckan
    - ./envs/.env_cps
    - ./envs/.env_dataproxy
    - ./envs/.env_gis

################################################

email:
  image: ${HDX_IMG_BASE}email:latest
  hostname: email
  restart: always
  volumes:
    - "${HDX_VOL_LOGS}/email:/var/log/email"
  ports:
    - "${HDX_SMTP_ADDR}:${HDX_SMTP_PORT}:25"
  env_file:
    - ./envs/.env_common
    - ./envs/.env_email
    - ./envs/.env_email_private

################################################

gisapi:
  image: ${HDX_IMG_BASE}gisapi:latest
  hostname: gisapi
  ports:
    - "${HDX_GISAPI_ADDR}:${HDX_GISAPI_PORT}:80"
    - "${HDX_GISAPI_DEBUG_ADDR}:${HDX_GISAPI_DEBUG_PORT}:5858"
  env_file:
    - ./envs/.env_common
    - ./envs/.env_gis_db
# ?? why not - ./envs/.env_gis_db_private

gisredis:
  image: ${HDX_IMG_BASE}redis:latest
  hostname: gisredis
  ports:
    - "${HDX_GISREDIS_ADDR}:${HDX_GISREDIS_PORT}:6379"
  env_file:
    - ./envs/.env_common

gislayer:
  image: ${HDX_IMG_BASE}gislayer:latest
  hostname: gislayer
  ports:
    - "${HDX_GISLAYER_ADDR}:${HDX_GISLAYER_PORT}:5000"
  extra_hosts:
    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  env_file:
    - ./envs/.env_common
    - ./envs/.env_gis_db
    - ./envs/.env_gis_db_private
    - ./envs/.env_gis_private

gisworker:
  image: ${HDX_IMG_BASE}gisworker:latest
  hostname: gisworker
  extra_hosts:
    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  env_file:
    - ./envs/.env_common
    - ./envs/.env_gis
    - ./envs/.env_gis_db
    - ./envs/.env_gis_db_private
    - ./envs/.env_gis_private
#  mem_limit: 1G

gisdb:
  image: ${HDX_IMG_BASE}psql-gis:latest
  hostname: gisdb
  volumes:
    - "${HDX_VOL_DBS}/psql-gis:/srv/db"
    - "${HDX_VOL_LOGS}/gis-psql:/var/log/psql"
  ports:
    - "${HDX_GISDB_ADDR}:${HDX_GISDB_PORT}:5432"
  env_file:
    - ./envs/.env_common

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
  env_file:
    - ./envs/.env_common

solr:
  image: ${HDX_IMG_BASE}solr:latest
  hostname: solr
  restart: always
  volumes:
    - "${HDX_VOL_DBS}/solr:/srv/solr/example/solr/ckan/data"
  ports:
    - "${HDX_SOLR_ADDR}:${HDX_SOLR_PORT}:8983"
  env_file:
    - ./envs/.env_common

dbckan:
  image: ${HDX_IMG_BASE}psql-ckan:latest
  hostname: dbckan
  restart: always
  volumes:
    - "${HDX_VOL_DBS}/psql-ckan:/srv/db"
    - "${HDX_VOL_LOGS}/ckan-psql:/var/log/psql"
  ports:
    - "${HDX_CKANDB_ADDR}:${HDX_CKANDB_PORT}:5432"
  env_file:
    - ./envs/.env_common
    - ./envs/.env_ckan_db_private

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
  env_file:
    - ./envs/.env_common
    - ./envs/.env_backup_private
    - ./envs/.env_ckan
    - ./envs/.env_ckan_private
    - ./envs/.env_ckan_db
    - ./envs/.env_ckan_db_private
    - ./envs/.env_dataproxy
    - ./envs/.env_email
    - ./envs/.env_gis
    - ./envs/.env_solr

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
  env_file:
    - ./envs/.env_common

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
  env_file:
    - ./envs/.env_common
    - ./envs/.env_backup_private
    - ./envs/.env_ckan_private
    - ./envs/.env_cps_db
    - ./envs/.env_cps_db_private
    - ./envs/.env_email

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
  env_file:
    - ./envs/.env_common

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
  env_file:
    - ./envs/.env_common
    - ./envs/.env_backup_private
    - ./envs/.env_blog
    - ./envs/.env_blog_db
    - ./envs/.env_blog_db_private

################################################
util:
  image: ${HDX_IMG_BASE}util:latest
  hostname: utility
#  restart: always
  volumes:
    - "${HDX_VOL_BACKUPS}:/srv/backup"
    - "${HDX_VOL_FILES}/filestore:/srv/filestore"
    - "${HDX_VOL_FILES}/gistmp:/srv/gistmp"
    - "${HDX_VOL_FILES}/www:/srv/www"
    - "${HDX_VOL_LOGS}:/srv/logs"
  extra_hosts:
    - "${HDX_PREFIX}docs.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    - "${HDX_PREFIX}manage.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  env_file:
    - ./envs/.env_backup_private
    - ./envs/.env_blog_db_private
    - ./envs/.env_blog_db
    - ./envs/.env_blog
    - ./envs/.env_ckan_db_private
    - ./envs/.env_ckan_db
    - ./envs/.env_ckan_private
    - ./envs/.env_ckan
    - ./envs/.env_common
    - ./envs/.env_cps_db_private
    - ./envs/.env_cps_db
    - ./envs/.env_cps
    - ./envs/.env_dataproxy
    - ./envs/.env_email_private
    - ./envs/.env_email
    - ./envs/.env_gis_db_private
    - ./envs/.env_gis_db
    - ./envs/.env_gis_private
    - ./envs/.env_gis
    - ./envs/.env_solr
    - ./envs/.env_web_private
    - ./envs/.env_web
################################################
jenkins:
  image: ${HDX_IMG_BASE}jenkins:latest
  hostname: jenkins
#  restart: always
  volumes:
    - "${HDX_VOL_BACKUPS}:/srv/backup"
  extra_hosts:
    - "${HDX_PREFIX}docs.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    - "${HDX_PREFIX}manage.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  env_file:
    - ./envs/.env_ckan_db_private
    - ./envs/.env_ckan_db
    - ./envs/.env_ckan_private
    - ./envs/.env_ckan
    - ./envs/.env_common
