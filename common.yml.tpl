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
  environment:
    # COMMON #
    TERM: 'xterm'
    HDX_DOMAIN: '${HDX_DOMAIN}'
    HDX_PREFIX: '${HDX_PREFIX}'
    HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
    HDX_TYPE: '${HDX_TYPE}'
    # BLOG #
    HDX_BLOG_ADDR: '${HDX_BLOG_ADDR}'
    HDX_BLOG_DIR: '${HDX_BLOG_DIR}'
    HDX_BLOG_PORT: '${HDX_BLOG_PORT}'
    # CKAN #
    HDX_CKAN_ADDR: '${HDX_CKAN_ADDR}'
    HDX_CKAN_BRANCH: '${HDX_CKAN_BRANCH}'
    HDX_CKAN_PORT: '${HDX_CKAN_PORT}'
    HDX_FILESTORE: '${HDX_FILESTORE}'
    # CPS #
    HDX_CPS_ADDR: '${HDX_CPS_ADDR}'
    HDX_CPS_BRANCH: '${HDX_CPS_BRANCH}'
    HDX_CPS_PORT: '${HDX_CPS_PORT}'
    # CPS_PROD_IP #
    HDX_PROD_CPS_ADDR: '${HDX_PROD_CPS_ADDR}'
    # CPS_OTHER #
    HDX_FOLDER: '${HDX_FOLDER}'
    # DATAPROXY #
    HDX_DATAPROXY_ADDR: '${HDX_DATAPROXY_ADDR}'
    HDX_DATAPROXY_PORT: '${HDX_DATAPROXY_PORT}'
    # GIS_API #
    HDX_GISAPI_ADDR: '${HDX_GISAPI_ADDR}'
    HDX_GISAPI_PORT: '${HDX_GISAPI_PORT}'
    #HDX_GISAPI_DEBUG_ADDR: '${HDX_GISAPI_DEBUG_ADDR}'
    #HDX_GISAPI_DEBUG_PORT: '${HDX_GISAPI_DEBUG_PORT}'
    # GIS_LAYER #
    HDX_GISLAYER_ADDR: '${HDX_GISLAYER_ADDR}'
    HDX_GISLAYER_PORT: '${HDX_GISLAYER_PORT}'
    # GIS_OTHER #
    HDX_GIS_TMP: '${HDX_GIS_TMP}'
    # SOLR #
    HDX_SOLR_ADDR: '${HDX_SOLR_ADDR}'
    HDX_SOLR_PORT: '${HDX_SOLR_PORT}'
    IS_MASTER: '${HDX_SOLR_IS_MASTER}'
    IS_SLAVE: '${HDX_SOLR_IS_SLAVE}'
    # WEB #
    HDX_HTTPS_REDIRECT: '${HDX_HTTPS_REDIRECT}'
    HDX_HTTPS_REDIRECT_ON_PROTO_HEADER: '${HDX_HTTPS_REDIRECT_ON_PROTO_HEADER}'
    VIRTUAL_HOST: '${VIRTUAL_HOST}'
    # WEB_PRV #
    HDX_NGINX_PASS: '${HDX_NGINX_PASS}'
    HDX_SSL_CRT: '${HDX_SSL_CRT}'
    HDX_SSL_KEY: '${HDX_SSL_KEY}'
    HDX_USER_AGENT: '${HDX_USER_AGENT}'

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
    # COMMON #
    TERM: 'xterm'
    HDX_DOMAIN: '${HDX_DOMAIN}'
    HDX_PREFIX: '${HDX_PREFIX}'
    HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
    HDX_TYPE: '${HDX_TYPE}'
    # EMAIL #
    HDX_SMTP_ADDR: '${HDX_SMTP_ADDR}'
    HDX_SMTP_PORT: '${HDX_SMTP_PORT}'
    # EMAIL_PRV #
    HDX_DKIM_CRT: '${HDX_DKIM_CRT}'
    HDX_DKIM_KEY: '${HDX_DKIM_KEY}'

################################################

gisapi:
  image: ${HDX_IMG_BASE}gisapi:latest
  hostname: gisapi
  ports:
    - "${HDX_GISAPI_ADDR}:${HDX_GISAPI_PORT}:80"
    - "${HDX_GISAPI_DEBUG_ADDR}:${HDX_GISAPI_DEBUG_PORT}:5858"
  environment:
    # COMMON #
    TERM: 'xterm'
    HDX_DOMAIN: '${HDX_DOMAIN}'
    HDX_PREFIX: '${HDX_PREFIX}'
    HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
    HDX_TYPE: '${HDX_TYPE}'
    # GIS_DB #
    HDX_GISDB_ADDR: '${HDX_GISDB_ADDR}'
    HDX_GISDB_PORT: '${HDX_GISDB_PORT}'
    # GIS_REDIS #
    HDX_GISREDIS_ADDR: '${HDX_GISREDIS_ADDR}'
    HDX_GISREDIS_PORT: '${HDX_GISREDIS_PORT}'
    # ?? why not GIS_PRV as well ??
    # GIS_PRV #
    #HDX_GIS_API_KEY: '${HDX_GIS_API_KEY}'


gisredis:
  image: ${HDX_IMG_BASE}redis:latest
  hostname: gisredis
  ports:
    - "${HDX_GISREDIS_ADDR}:${HDX_GISREDIS_PORT}:6379"
  environment:
    # COMMON #
    TERM: 'xterm'
    HDX_DOMAIN: '${HDX_DOMAIN}'
    HDX_PREFIX: '${HDX_PREFIX}'
    HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
    HDX_TYPE: '${HDX_TYPE}'

gislayer:
  image: ${HDX_IMG_BASE}gislayer:latest
  hostname: gislayer
  ports:
    - "${HDX_GISLAYER_ADDR}:${HDX_GISLAYER_PORT}:5000"
  extra_hosts:
    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  environment:
    # COMMON #
    TERM: 'xterm'
    HDX_DOMAIN: '${HDX_DOMAIN}'
    HDX_PREFIX: '${HDX_PREFIX}'
    HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
    HDX_TYPE: '${HDX_TYPE}'
    # GIS_DB #
    HDX_GISDB_ADDR: '${HDX_GISDB_ADDR}'
    HDX_GISDB_PORT: '${HDX_GISDB_PORT}'
    # GIS_REDIS #
    HDX_GISREDIS_ADDR: '${HDX_GISREDIS_ADDR}'
    HDX_GISREDIS_PORT: '${HDX_GISREDIS_PORT}'
    # GIS_DB_PRV #
    HDX_GISDB_DB: '${HDX_GISDB_DB}'
    HDX_GISDB_USER: '${HDX_GISDB_USER}'
    HDX_GISDB_PASS: '${HDX_GISDB_PASS}'
    # GIS_PRV #
    HDX_GIS_API_KEY: '${HDX_GIS_API_KEY}'

gisworker:
  image: ${HDX_IMG_BASE}gisworker:latest
  hostname: gisworker
  extra_hosts:
    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  environment:
    # COMMON #
    TERM: 'xterm'
    HDX_DOMAIN: '${HDX_DOMAIN}'
    HDX_PREFIX: '${HDX_PREFIX}'
    HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
    HDX_TYPE: '${HDX_TYPE}'
    # GIS_API #
    HDX_GISAPI_ADDR: '${HDX_GISAPI_ADDR}'
    HDX_GISAPI_PORT: '${HDX_GISAPI_PORT}'
    #HDX_GISAPI_DEBUG_ADDR: '${HDX_GISAPI_DEBUG_ADDR}'
    #HDX_GISAPI_DEBUG_PORT: '${HDX_GISAPI_DEBUG_PORT}'
    # GIS_LAYER #
    HDX_GISLAYER_ADDR: '${HDX_GISLAYER_ADDR}'
    HDX_GISLAYER_PORT: '${HDX_GISLAYER_PORT}'
    # GIS_OTHER #
    HDX_GIS_TMP: '${HDX_GIS_TMP}'
    # GIS_DB #
    HDX_GISDB_ADDR: '${HDX_GISDB_ADDR}'
    HDX_GISDB_PORT: '${HDX_GISDB_PORT}'
    # GIS_REDIS #
    HDX_GISREDIS_ADDR: '${HDX_GISREDIS_ADDR}'
    HDX_GISREDIS_PORT: '${HDX_GISREDIS_PORT}'
    # GIS_DB_PRV #
    HDX_GISDB_DB: '${HDX_GISDB_DB}'
    HDX_GISDB_USER: '${HDX_GISDB_USER}'
    HDX_GISDB_PASS: '${HDX_GISDB_PASS}'
    # GIS_PRV #
    HDX_GIS_API_KEY: '${HDX_GIS_API_KEY}'
#  mem_limit: 1G

gisdb:
  image: ${HDX_IMG_BASE}psql-gis:latest
  hostname: gisdb
  volumes:
    - "${HDX_VOL_DBS}/psql-gis:/srv/db"
    - "${HDX_VOL_LOGS}/gis-psql:/var/log/psql"
  ports:
    - "${HDX_GISDB_ADDR}:${HDX_GISDB_PORT}:5432"
  environment:
    # COMMON #
    TERM: 'xterm'
    HDX_DOMAIN: '${HDX_DOMAIN}'
    HDX_PREFIX: '${HDX_PREFIX}'
    HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
    HDX_TYPE: '${HDX_TYPE}'

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
  environment:
    # COMMON #
    TERM: 'xterm'
    HDX_DOMAIN: '${HDX_DOMAIN}'
    HDX_PREFIX: '${HDX_PREFIX}'
    HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
    HDX_TYPE: '${HDX_TYPE}'

solr:
  image: ${HDX_IMG_BASE}solr:latest
  hostname: solr
  restart: always
  volumes:
    - "${HDX_VOL_DBS}/solr:/srv/solr/example/solr/ckan/data"
  ports:
    - "${HDX_SOLR_ADDR}:${HDX_SOLR_PORT}:8983"
  environment:
    # COMMON #
    TERM: 'xterm'
    HDX_DOMAIN: '${HDX_DOMAIN}'
    HDX_PREFIX: '${HDX_PREFIX}'
    HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
    HDX_TYPE: '${HDX_TYPE}'
    # SOLR #
    HDX_SOLR_ADDR: '${HDX_SOLR_ADDR}'
    HDX_SOLR_PORT: '${HDX_SOLR_PORT}'
    IS_MASTER: '${HDX_SOLR_IS_MASTER}'
    IS_SLAVE: '${HDX_SOLR_IS_SLAVE}'

dbckan:
  image: ${HDX_IMG_BASE}psql-ckan:latest
  hostname: dbckan
  restart: always
  volumes:
    - "${HDX_VOL_DBS}/psql-ckan:/srv/db"
    - "${HDX_VOL_LOGS}/ckan-psql:/var/log/psql"
  ports:
    - "${HDX_CKANDB_ADDR}:${HDX_CKANDB_PORT}:5432"
  environment:
    # COMMON #
    TERM: 'xterm'
    HDX_DOMAIN: '${HDX_DOMAIN}'
    HDX_PREFIX: '${HDX_PREFIX}'
    HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
    HDX_TYPE: '${HDX_TYPE}'
    # CKAN_DB_PRV #
    HDX_CKANDB_DB_DATASTORE: '${HDX_CKANDB_DB_DATASTORE}'
    HDX_CKANDB_DB: '${HDX_CKANDB_DB}'
    HDX_CKANDB_PASS_DATASTORE: '${HDX_CKANDB_PASS_DATASTORE}'
    HDX_CKANDB_PASS: '${HDX_CKANDB_PASS}'
    HDX_CKANDB_USER_DATASTORE: '${HDX_CKANDB_USER_DATASTORE}'
    HDX_CKANDB_USER: '${HDX_CKANDB_USER}'

ckan:
  image: ${HDX_IMG_BASE}ckan:latest
  hostname: ckan
  restart: always
  volumes:
    - "${HDX_VOL_BACKUPS}:/srv/backup"
    - "${HDX_VOL_FILES}/filestore:${HDX_FILESTORE}"
    - "${HDX_VOL_LOGS}/ckan:/var/log/ckan"
  ports:
    - "${HDX_CKAN_ADDR}:${HDX_CKAN_PORT}:5000"
  extra_hosts:
    - "${HDX_PREFIX}docs.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    - "${HDX_PREFIX}manage.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  environment:
    # COMMON #
    TERM: 'xterm'
    HDX_DOMAIN: '${HDX_DOMAIN}'
    HDX_PREFIX: '${HDX_PREFIX}'
    HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
    HDX_TYPE: '${HDX_TYPE}'
    # BACKUP_PRV #
    HDX_BACKUP_BASE_DIR: '${HDX_BACKUP_BASE_DIR}'
    HDX_BACKUP_DIR: '${HDX_BACKUP_DIR}'
    HDX_BACKUP_SERVER: '${HDX_BACKUP_SERVER}'
    HDX_BACKUP_USER: '${HDX_BACKUP_USER}'
    HDX_SSH_KEY: '${HDX_SSH_KEY}'
    HDX_SSH_PUB: '${HDX_SSH_PUB}'
    # CKAN #
    HDX_CKAN_ADDR: '${HDX_CKAN_ADDR}'
    HDX_CKAN_BRANCH: '${HDX_CKAN_BRANCH}'
    HDX_CKAN_PORT: '${HDX_CKAN_PORT}'
    HDX_FILESTORE: '${HDX_FILESTORE}'
    # CKAN_DB #
    HDX_CKANDB_ADDR: '${HDX_CKANDB_ADDR}'
    HDX_CKANDB_PORT: '${HDX_CKANDB_PORT}'
    # CKAN_DB_PRV #
    HDX_CKANDB_DB_DATASTORE: '${HDX_CKANDB_DB_DATASTORE}'
    HDX_CKANDB_DB: '${HDX_CKANDB_DB}'
    HDX_CKANDB_PASS_DATASTORE: '${HDX_CKANDB_PASS_DATASTORE}'
    HDX_CKANDB_PASS: '${HDX_CKANDB_PASS}'
    HDX_CKANDB_USER_DATASTORE: '${HDX_CKANDB_USER_DATASTORE}'
    HDX_CKANDB_USER: '${HDX_CKANDB_USER}'
    # CKAN_PRV #
    HDX_CKAN_API_KEY: '${HDX_CKAN_API_KEY}'
    HDX_CKAN_RECAPTCHA_KEY: '${HDX_CKAN_RECAPTCHA_KEY}'
    HDX_GOOGLE_DEV_KEY: '${HDX_GOOGLE_DEV_KEY}'
    # DATAPROXY #
    HDX_DATAPROXY_ADDR: '${HDX_DATAPROXY_ADDR}'
    HDX_DATAPROXY_PORT: '${HDX_DATAPROXY_PORT}'
    # EMAIL #
    HDX_SMTP_ADDR: '${HDX_SMTP_ADDR}'
    HDX_SMTP_PORT: '${HDX_SMTP_PORT}'
    # GIS_API #
    HDX_GISAPI_ADDR: '${HDX_GISAPI_ADDR}'
    HDX_GISAPI_PORT: '${HDX_GISAPI_PORT}'
    #HDX_GISAPI_DEBUG_ADDR: '${HDX_GISAPI_DEBUG_ADDR}'
    #HDX_GISAPI_DEBUG_PORT: '${HDX_GISAPI_DEBUG_PORT}'
    # GIS_LAYER #
    HDX_GISLAYER_ADDR: '${HDX_GISLAYER_ADDR}'
    HDX_GISLAYER_PORT: '${HDX_GISLAYER_PORT}'
    # GIS_OTHER #
    HDX_GIS_TMP: '${HDX_GIS_TMP}'
    # GIS_DB #
    HDX_GISDB_ADDR: '${HDX_GISDB_ADDR}'
    HDX_GISDB_PORT: '${HDX_GISDB_PORT}'
    # GIS_REDIS #
    HDX_GISREDIS_ADDR: '${HDX_GISREDIS_ADDR}'
    HDX_GISREDIS_PORT: '${HDX_GISREDIS_PORT}'
    # GIS_DB_PRV #
    HDX_GISDB_DB: '${HDX_GISDB_DB}'
    HDX_GISDB_USER: '${HDX_GISDB_USER}'
    HDX_GISDB_PASS: '${HDX_GISDB_PASS}'
    # SOLR #
    HDX_SOLR_ADDR: '${HDX_SOLR_ADDR}'
    HDX_SOLR_PORT: '${HDX_SOLR_PORT}'
    IS_MASTER: '${HDX_SOLR_IS_MASTER}'
    IS_SLAVE: '${HDX_SOLR_IS_SLAVE}'

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
  environment:
    # COMMON #
    TERM: 'xterm'
    HDX_DOMAIN: '${HDX_DOMAIN}'
    HDX_PREFIX: '${HDX_PREFIX}'
    HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
    HDX_TYPE: '${HDX_TYPE}'

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
    # COMMON #
    TERM: 'xterm'
    HDX_DOMAIN: '${HDX_DOMAIN}'
    HDX_PREFIX: '${HDX_PREFIX}'
    HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
    HDX_TYPE: '${HDX_TYPE}'
    # BACKUP_PRV #
    HDX_BACKUP_BASE_DIR: '${HDX_BACKUP_BASE_DIR}'
    HDX_BACKUP_DIR: '${HDX_BACKUP_DIR}'
    HDX_BACKUP_SERVER: '${HDX_BACKUP_SERVER}'
    HDX_BACKUP_USER: '${HDX_BACKUP_USER}'
    HDX_SSH_KEY: '${HDX_SSH_KEY}'
    HDX_SSH_PUB: '${HDX_SSH_PUB}'
    # CKAN_PRV #
    HDX_CKAN_API_KEY: '${HDX_CKAN_API_KEY}'
    HDX_CKAN_RECAPTCHA_KEY: '${HDX_CKAN_RECAPTCHA_KEY}'
    HDX_GOOGLE_DEV_KEY: '${HDX_GOOGLE_DEV_KEY}'
    # CPS #
    HDX_CPS_ADDR: '${HDX_CPS_ADDR}'
    HDX_CPS_BRANCH: '${HDX_CPS_BRANCH}'
    HDX_CPS_PORT: '${HDX_CPS_PORT}'
    # CPS_PROD_IP #
    HDX_PROD_CPS_ADDR: '${HDX_PROD_CPS_ADDR}'
    # CPS_OTHER #
    HDX_FOLDER: '${HDX_FOLDER}'
    # CPS_DB #
    HDX_CPSDB_ADDR: '${HDX_CPSDB_ADDR}'
    HDX_CPSDB_PORT: '${HDX_CPSDB_PORT}'
    # CPS_DB_PRV #
    HDX_CPSDB_DB: '${HDX_CPSDB_DB}'
    HDX_CPSDB_PASS: '${HDX_CPSDB_PASS}'
    HDX_CPSDB_USER: '${HDX_CPSDB_USER}'
    # EMAIL #
    HDX_SMTP_ADDR: '${HDX_SMTP_ADDR}'
    HDX_SMTP_PORT: '${HDX_SMTP_PORT}'

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
  environment:
    # COMMON #
    TERM: 'xterm'
    HDX_DOMAIN: '${HDX_DOMAIN}'
    HDX_PREFIX: '${HDX_PREFIX}'
    HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
    HDX_TYPE: '${HDX_TYPE}'

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
    # COMMON #
    TERM: 'xterm'
    HDX_DOMAIN: '${HDX_DOMAIN}'
    HDX_PREFIX: '${HDX_PREFIX}'
    HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
    HDX_TYPE: '${HDX_TYPE}'
    # BLOG #
    HDX_BLOG_ADDR: '${HDX_BLOG_ADDR}'
    HDX_BLOG_DIR: '${HDX_BLOG_DIR}'
    HDX_BLOG_PORT: '${HDX_BLOG_PORT}'
    # BACKUP_PRV #
    HDX_BACKUP_BASE_DIR: '${HDX_BACKUP_BASE_DIR}'
    HDX_BACKUP_DIR: '${HDX_BACKUP_DIR}'
    HDX_BACKUP_SERVER: '${HDX_BACKUP_SERVER}'
    HDX_BACKUP_USER: '${HDX_BACKUP_USER}'
    HDX_SSH_KEY: '${HDX_SSH_KEY}'
    HDX_SSH_PUB: '${HDX_SSH_PUB}'
    # BLOG_DB #
    HDX_BLOGDB_ADDR: '${HDX_BLOGDB_ADDR}'
    HDX_BLOGDB_PORT: '${HDX_BLOGDB_PORT}'
    # BLOG_DB_PRV #
    HDX_BLOGDB_DB: '${HDX_BLOGDB_DB}'
    HDX_BLOGDB_USER: '${HDX_BLOGDB_USER}'
    HDX_BLOGDB_PASS: '${HDX_BLOGDB_PASS}'

################################################
util:
  image: ${HDX_IMG_BASE}util:latest
  hostname: utility
#  restart: always
  volumes:
    - "${HDX_VOL_BACKUPS}:/srv/backup"
    - "${HDX_VOL_FILES}/filestore:${HDX_FILESTORE}"
    - "${HDX_VOL_FILES}/gistmp:/srv/gistmp"
    - "${HDX_VOL_FILES}/www:/srv/www"
    - "${HDX_VOL_LOGS}:/srv/logs"
  extra_hosts:
    - "${HDX_PREFIX}docs.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    - "${HDX_PREFIX}manage.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  environment:
    # COMMON #
    TERM: 'xterm'
    HDX_DOMAIN: '${HDX_DOMAIN}'
    HDX_PREFIX: '${HDX_PREFIX}'
    HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
    HDX_TYPE: '${HDX_TYPE}'
    # BLOG #
    HDX_BLOG_ADDR: '${HDX_BLOG_ADDR}'
    HDX_BLOG_DIR: '${HDX_BLOG_DIR}'
    HDX_BLOG_PORT: '${HDX_BLOG_PORT}'
    # BACKUP_PRV #
    HDX_BACKUP_BASE_DIR: '${HDX_BACKUP_BASE_DIR}'
    HDX_BACKUP_DIR: '${HDX_BACKUP_DIR}'
    HDX_BACKUP_SERVER: '${HDX_BACKUP_SERVER}'
    HDX_BACKUP_USER: '${HDX_BACKUP_USER}'
    HDX_SSH_KEY: '${HDX_SSH_KEY}'
    HDX_SSH_PUB: '${HDX_SSH_PUB}'
    # BLOG_DB #
    HDX_BLOGDB_ADDR: '${HDX_BLOGDB_ADDR}'
    HDX_BLOGDB_PORT: '${HDX_BLOGDB_PORT}'
    # BLOG_DB_PRV #
    HDX_BLOGDB_DB: '${HDX_BLOGDB_DB}'
    HDX_BLOGDB_USER: '${HDX_BLOGDB_USER}'
    HDX_BLOGDB_PASS: '${HDX_BLOGDB_PASS}'
    # CKAN #
    HDX_CKAN_ADDR: '${HDX_CKAN_ADDR}'
    HDX_CKAN_BRANCH: '${HDX_CKAN_BRANCH}'
    HDX_CKAN_PORT: '${HDX_CKAN_PORT}'
    HDX_FILESTORE: '${HDX_FILESTORE}'
    # CKAN_DB #
    HDX_CKANDB_ADDR: '${HDX_CKANDB_ADDR}'
    HDX_CKANDB_PORT: '${HDX_CKANDB_PORT}'
    # CKAN_DB_PRV #
    HDX_CKANDB_DB_DATASTORE: '${HDX_CKANDB_DB_DATASTORE}'
    HDX_CKANDB_DB: '${HDX_CKANDB_DB}'
    HDX_CKANDB_PASS_DATASTORE: '${HDX_CKANDB_PASS_DATASTORE}'
    HDX_CKANDB_PASS: '${HDX_CKANDB_PASS}'
    HDX_CKANDB_USER_DATASTORE: '${HDX_CKANDB_USER_DATASTORE}'
    HDX_CKANDB_USER: '${HDX_CKANDB_USER}'
    # CKAN_PRV #
    HDX_CKAN_API_KEY: '${HDX_CKAN_API_KEY}'
    HDX_CKAN_RECAPTCHA_KEY: '${HDX_CKAN_RECAPTCHA_KEY}'
    HDX_GOOGLE_DEV_KEY: '${HDX_GOOGLE_DEV_KEY}'
    # CPS #
    HDX_CPS_ADDR: '${HDX_CPS_ADDR}'
    HDX_CPS_BRANCH: '${HDX_CPS_BRANCH}'
    HDX_CPS_PORT: '${HDX_CPS_PORT}'
    # CPS_PROD_IP #
    HDX_PROD_CPS_ADDR: '${HDX_PROD_CPS_ADDR}'
    # CPS_OTHER #
    HDX_FOLDER: '${HDX_FOLDER}'
    # CPS_DB #
    HDX_CPSDB_ADDR: '${HDX_CPSDB_ADDR}'
    HDX_CPSDB_PORT: '${HDX_CPSDB_PORT}'
    # CPS_DB_PRV #
    HDX_CPSDB_DB: '${HDX_CPSDB_DB}'
    HDX_CPSDB_PASS: '${HDX_CPSDB_PASS}'
    HDX_CPSDB_USER: '${HDX_CPSDB_USER}'
    # DATAPROXY #
    HDX_DATAPROXY_ADDR: '${HDX_DATAPROXY_ADDR}'
    HDX_DATAPROXY_PORT: '${HDX_DATAPROXY_PORT}'
    # EMAIL #
    HDX_SMTP_ADDR: '${HDX_SMTP_ADDR}'
    HDX_SMTP_PORT: '${HDX_SMTP_PORT}'
    # EMAIL_PRV #
    HDX_DKIM_CRT: '${HDX_DKIM_CRT}'
    HDX_DKIM_KEY: '${HDX_DKIM_KEY}'
    # GIS_API #
    HDX_GISAPI_ADDR: '${HDX_GISAPI_ADDR}'
    HDX_GISAPI_PORT: '${HDX_GISAPI_PORT}'
    #HDX_GISAPI_DEBUG_ADDR: '${HDX_GISAPI_DEBUG_ADDR}'
    #HDX_GISAPI_DEBUG_PORT: '${HDX_GISAPI_DEBUG_PORT}'
    # GIS_LAYER #
    HDX_GISLAYER_ADDR: '${HDX_GISLAYER_ADDR}'
    HDX_GISLAYER_PORT: '${HDX_GISLAYER_PORT}'
    # GIS_OTHER #
    HDX_GIS_TMP: '${HDX_GIS_TMP}'
    # GIS_DB #
    HDX_GISDB_ADDR: '${HDX_GISDB_ADDR}'
    HDX_GISDB_PORT: '${HDX_GISDB_PORT}'
    # GIS_REDIS #
    HDX_GISREDIS_ADDR: '${HDX_GISREDIS_ADDR}'
    HDX_GISREDIS_PORT: '${HDX_GISREDIS_PORT}'
    # GIS_DB_PRV #
    HDX_GISDB_DB: '${HDX_GISDB_DB}'
    HDX_GISDB_USER: '${HDX_GISDB_USER}'
    HDX_GISDB_PASS: '${HDX_GISDB_PASS}'
    # GIS_PRV #
    HDX_GIS_API_KEY: '${HDX_GIS_API_KEY}'
    # SOLR #
    HDX_SOLR_ADDR: '${HDX_SOLR_ADDR}'
    HDX_SOLR_PORT: '${HDX_SOLR_PORT}'
    IS_MASTER: '${HDX_SOLR_IS_MASTER}'
    IS_SLAVE: '${HDX_SOLR_IS_SLAVE}'
    # WEB #
    HDX_HTTPS_REDIRECT: '${HDX_HTTPS_REDIRECT}'
    HDX_HTTPS_REDIRECT_ON_PROTO_HEADER: '${HDX_HTTPS_REDIRECT_ON_PROTO_HEADER}'
    VIRTUAL_HOST: '${VIRTUAL_HOST}'
    # WEB_PRV #
    HDX_NGINX_PASS: '${HDX_NGINX_PASS}'
    HDX_SSL_CRT: '${HDX_SSL_CRT}'
    HDX_SSL_KEY: '${HDX_SSL_KEY}'
    HDX_USER_AGENT: '${HDX_USER_AGENT}'

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
  environment:
    # COMMON #
    TERM: 'xterm'
    HDX_DOMAIN: '${HDX_DOMAIN}'
    HDX_PREFIX: '${HDX_PREFIX}'
    HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
    HDX_TYPE: '${HDX_TYPE}'
    # CKAN #
    HDX_CKAN_ADDR: '${HDX_CKAN_ADDR}'
    HDX_CKAN_BRANCH: '${HDX_CKAN_BRANCH}'
    HDX_CKAN_PORT: '${HDX_CKAN_PORT}'
    HDX_FILESTORE '${HDX_FILESTORE}'
    # CKAN_DB #
    HDX_CKANDB_ADDR: '${HDX_CKANDB_ADDR}'
    HDX_CKANDB_PORT: '${HDX_CKANDB_PORT}'
    # CKAN_DB_PRV #
    HDX_CKANDB_DB_DATASTORE: '${HDX_CKANDB_DB_DATASTORE}'
    HDX_CKANDB_DB: '${HDX_CKANDB_DB}'
    HDX_CKANDB_PASS_DATASTORE: '${HDX_CKANDB_PASS_DATASTORE}'
    HDX_CKANDB_PASS: '${HDX_CKANDB_PASS}'
    HDX_CKANDB_USER_DATASTORE: '${HDX_CKANDB_USER_DATASTORE}'
    HDX_CKANDB_USER: '${HDX_CKANDB_USER}'
    # CKAN_PRV #
    HDX_CKAN_API_KEY: '${HDX_CKAN_API_KEY}'
    HDX_CKAN_RECAPTCHA_KEY: '${HDX_CKAN_RECAPTCHA_KEY}'
    HDX_GOOGLE_DEV_KEY: '${HDX_GOOGLE_DEV_KEY}'
