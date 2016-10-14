# copyleft 2015 teodorescu.serban@gmail.com

################################################


version: "2"

networks:
  proxy:
    external:
      name: nginx-proxy

services:
  web:
    image: ${HDX_IMG_BASE}nginx:latest
    hostname: ${PREFIX}-${STACK}-web
    container_name: ${PREFIX}-${STACK}-web
    restart: always
    volumes:
      - "./etc/nginx:/etc/nginx"
      - "${HDX_VOL_FILES}/www:/srv/www"
      - "${HDX_VOL_LOGS}/nginx:/var/log/nginx"
  #  ports:
  #    - "${HDX_WB_ADDR}:${HDX_HTTP_PORT}:80"
  #    - "${HDX_WB_ADDR}:${HDX_HTTPS_PORT}:443"
    environment:
      # COMMON #
      TERM: 'xterm'
      HDX_DOMAIN: '${HDX_DOMAIN}'
      HDX_PREFIX: '${HDX_PREFIX}'
      HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
      HDX_TYPE: '${HDX_TYPE}'
      # BLOG #
  #    HDX_BLOG_ADDR: '${HDX_BLOG_ADDR}'
      HDX_BLOG_DIR: '${HDX_BLOG_DIR}'
  #    HDX_BLOG_PORT: '${HDX_BLOG_PORT}'
      # CKAN #
  #    HDX_CKAN_ADDR: '${HDX_CKAN_ADDR}'
      HDX_CKAN_BRANCH: '${HDX_CKAN_BRANCH}'
  #    HDX_CKAN_PORT: '${HDX_CKAN_PORT}'
      HDX_FILESTORE: '${HDX_FILESTORE}'
      # CPS #
  #    HDX_CPS_ADDR: '${HDX_CPS_ADDR}'
      HDX_CPS_BRANCH: '${HDX_CPS_BRANCH}'
  #    HDX_CPS_PORT: '${HDX_CPS_PORT}'
      # CPS_PROD_IP #
      HDX_PROD_CPS_ADDR: '${HDX_PROD_CPS_ADDR}'
      # CPS_OTHER #
      HDX_FOLDER: '${HDX_FOLDER}'
      # DATAPROXY #
  #    HDX_DATAPROXY_ADDR: '${HDX_DATAPROXY_ADDR}'
  #    HDX_DATAPROXY_PORT: '${HDX_DATAPROXY_PORT}'
      # GIS_API #
  #    HDX_GISAPI_ADDR: '${HDX_GISAPI_ADDR}'
  #    HDX_GISAPI_PORT: '${HDX_GISAPI_PORT}'
      #HDX_GISAPI_DEBUG_ADDR: '${HDX_GISAPI_DEBUG_ADDR}'
      #HDX_GISAPI_DEBUG_PORT: '${HDX_GISAPI_DEBUG_PORT}'
      # GIS_LAYER #
  #    HDX_GISLAYER_ADDR: '${HDX_GISLAYER_ADDR}'
  #    HDX_GISLAYER_PORT: '${HDX_GISLAYER_PORT}'
      # GIS_OTHER #
      HDX_GIS_TMP: '${HDX_GIS_TMP}'
      # SOLR #
  #    HDX_SOLR_ADDR: '${HDX_SOLR_ADDR}'
  #    HDX_SOLR_PORT: '${HDX_SOLR_PORT}'
      IS_MASTER: '${HDX_SOLR_IS_MASTER}'
      IS_SLAVE: '${HDX_SOLR_IS_SLAVE}'
      # WEB #
      HDX_HTTPS_REDIRECT: '${HDX_HTTPS_REDIRECT}'
      HDX_HTTPS_REDIRECT_ON_PROTO_HEADER: '${HDX_HTTPS_REDIRECT_ON_PROTO_HEADER}'
      #VIRTUAL_HOST: '${VIRTUAL_HOST}'
      # WEB_PRV #
      HDX_NGINX_PASS: '${HDX_NGINX_PASS}'
      HDX_SSL_CRT: '${HDX_SSL_CRT}'
      HDX_SSL_KEY: '${HDX_SSL_KEY}'
      HDX_USER_AGENT: '${HDX_USER_AGENT}'
      VIRTUAL_HOST: '${VIRTUAL_HOST}'
      VIRTUAL_PORT: '80'
      VIRTUAL_NETWORK: 'nginx-proxy'
      LETSENCRYPT_HOST: '${VIRTUAL_HOST}'
      LETSENCRYPT_EMAIL: 'ops+hrinfo@humanitarianresponse.info'
    networks:
      default:
      proxy:

  ################################################

  email:
    image: ${HDX_IMG_BASE}email:latest
    hostname: ${PREFIX}-${STACK}-email
    container_name: ${PREFIX}-${STACK}-email
    restart: always
    volumes:
      - "${HDX_VOL_LOGS}/email:/var/log/email"
  #  ports:
  #    - "${HDX_SMTP_ADDR}:${HDX_SMTP_PORT}:25"
    environment:
      # COMMON #
      TERM: 'xterm'
      HDX_DOMAIN: '${HDX_DOMAIN}'
      HDX_PREFIX: '${HDX_PREFIX}'
      HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
      HDX_TYPE: '${HDX_TYPE}'
      # EMAIL #
  #    HDX_SMTP_ADDR: '${HDX_SMTP_ADDR}'
  #    HDX_SMTP_PORT: '${HDX_SMTP_PORT}'
      # EMAIL_PRV #
      HDX_DKIM_CRT: '${HDX_DKIM_CRT}'
      HDX_DKIM_KEY: '${HDX_DKIM_KEY}'

  ################################################

  mpx:
    image: teodorescuserban/hdx-mpx:latest
    hostname: ${PREFIX}-${STACK}-mpx
    container_name: ${PREFIX}-${STACK}-mpx
    volumes:
      - "${HDX_VOL_FILES}/www/visualization/mpx:/dst"
    command: /deploy.sh

  hxlpreview-builder:
    image: teodorescuserban/hdx-hxlpreview-builder:latest
    hostname: ${PREFIX}-${STACK}-hxlpreview-builder
    container_name: ${PREFIX}-${STACK}-hxlpreview-builder
    volumes:
      - "${HDX_VOL_FILES}/src:/src"
      - "${HDX_VOL_FILES}/www/visualization/hxlpreview:/dst"

  hxlproxy:
    #image: teodorescuserban/hxl-proxy:latest
    image: teodorescuserban/hxl-proxy:test-201611
    hostname: ${PREFIX}-${STACK}-hxlproxy
    container_name: ${PREFIX}-${STACK}-hxlproxy

  ################################################

  gisapi:
    image: ${HDX_IMG_BASE}gisapi:latest
    hostname: ${PREFIX}-${STACK}-gisapi
    container_name: ${PREFIX}-${STACK}-gisapi
  #  ports:
  #    - "${HDX_GISAPI_ADDR}:${HDX_GISAPI_PORT}:80"
  #    - "${HDX_GISAPI_DEBUG_ADDR}:${HDX_GISAPI_DEBUG_PORT}:5858"
    environment:
      # COMMON #
      TERM: 'xterm'
      HDX_DOMAIN: '${HDX_DOMAIN}'
      HDX_PREFIX: '${HDX_PREFIX}'
      HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
      HDX_TYPE: '${HDX_TYPE}'
      # GIS_DB #
  #    HDX_GISDB_ADDR: '${HDX_GISDB_ADDR}'
  #    HDX_GISDB_PORT: '${HDX_GISDB_PORT}'
      # GIS_REDIS #
  #    HDX_GISREDIS_ADDR: '${HDX_GISREDIS_ADDR}'
  #    HDX_GISREDIS_PORT: '${HDX_GISREDIS_PORT}'
      # GIS_DB_PRV #
      HDX_GISDB_DB: '${HDX_GISDB_DB}'
      HDX_GISDB_USER: '${HDX_GISDB_USER}'
      HDX_GISDB_PASS: '${HDX_GISDB_PASS}'
      # ?? why not GIS_PRV as well ??
      # GIS_PRV #
      #HDX_GIS_API_KEY: '${HDX_GIS_API_KEY}'


  gisredis:
    image: unocha/alpine-redis:latest
    #image: ${HDX_IMG_BASE}redis:latest
    hostname: ${PREFIX}-${STACK}-gisredis
    container_name: ${PREFIX}-${STACK}-gisredis
    volumes:
      - "${HDX_VOL_DBS}/redis:/var/lib/redis"
      - "${HDX_VOL_LOGS}/redis:/var/log/redis"
  #  ports:
  #    - "${HDX_GISREDIS_ADDR}:${HDX_GISREDIS_PORT}:6379"
    environment:
      # COMMON #
      TERM: 'xterm'
      HDX_DOMAIN: '${HDX_DOMAIN}'
      HDX_PREFIX: '${HDX_PREFIX}'
      HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
      HDX_TYPE: '${HDX_TYPE}'

  gislayer:
    #image: ${HDX_IMG_BASE}gislayer:latest
    #image: unocha/alpine-base-s6:3.4
    image: gis2l
    hostname: ${PREFIX}-${STACK}-gislayer
    container_name: ${PREFIX}-${STACK}-gislayer
  #  ports:
  #    - "${HDX_GISLAYER_ADDR}:${HDX_GISLAYER_PORT}:5000"
  #  extra_hosts:
  #    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    environment:
      # COMMON #
      TERM: 'xterm'
      HDX_DOMAIN: '${HDX_DOMAIN}'
      HDX_PREFIX: '${HDX_PREFIX}'
      HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
      HDX_TYPE: '${HDX_TYPE}'
      # to remove gis db addr and port AND gis redis addr and port, we need to change 
      # the app.conf.tpl 
      # GIS_DB #
      HDX_GISDB_ADDR: 'gisdb'
      HDX_GISDB_PORT: '5432'
      # GIS_REDIS #
      HDX_GISREDIS_ADDR: 'gisredis'
      HDX_GISREDIS_PORT: '6379'
      # GIS_DB_PRV #
      HDX_GISDB_DB: '${HDX_GISDB_DB}'
      HDX_GISDB_USER: '${HDX_GISDB_USER}'
      HDX_GISDB_PASS: '${HDX_GISDB_PASS}'
      HDX_GIS_TMP: '${HDX_GIS_TMP}'
      # GIS_PRV #
      HDX_GIS_API_KEY: '${HDX_GIS_API_KEY}'

  gisworker:
    #image: ${HDX_IMG_BASE}gisworker:latest
    #image: unocha/alpine-base-s6:3.4
    image: gis3w
    hostname: ${PREFIX}-${STACK}-gisworker
    container_name: ${PREFIX}-${STACK}-gisworker
  #  extra_hosts:
  #    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    environment:
      # COMMON #
      TERM: 'xterm'
      HDX_DOMAIN: '${HDX_DOMAIN}'
      HDX_PREFIX: '${HDX_PREFIX}'
      HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
      HDX_TYPE: '${HDX_TYPE}'
      # GIS_API #
  #    HDX_GISAPI_ADDR: '${HDX_GISAPI_ADDR}'
  #    HDX_GISAPI_PORT: '${HDX_GISAPI_PORT}'
      #HDX_GISAPI_DEBUG_ADDR: '${HDX_GISAPI_DEBUG_ADDR}'
      #HDX_GISAPI_DEBUG_PORT: '${HDX_GISAPI_DEBUG_PORT}'
      # GIS_LAYER #
  #    HDX_GISLAYER_ADDR: '${HDX_GISLAYER_ADDR}'
  #    HDX_GISLAYER_PORT: '${HDX_GISLAYER_PORT}'
      # GIS_OTHER #
      HDX_GIS_TMP: '${HDX_GIS_TMP}'
      # to remove gis db addr and port AND gis redis addr and port, we need to change 
      # the app.conf.tpl 
      # GIS_DB #
      HDX_GISDB_ADDR: 'gisdb'
      HDX_GISDB_PORT: '5432'
      # GIS_REDIS #
      HDX_GISREDIS_ADDR: 'gisredis'
      HDX_GISREDIS_PORT: '6379'
      # GIS_DB_PRV #
      HDX_GISDB_DB: '${HDX_GISDB_DB}'
      HDX_GISDB_USER: '${HDX_GISDB_USER}'
      HDX_GISDB_PASS: '${HDX_GISDB_PASS}'
      # GIS_PRV #
      HDX_GIS_API_KEY: '${HDX_GIS_API_KEY}'
  #  mem_limit: 1G

  gisdb:
    image: unocha/alpine-base-postgis:2010-PR90
    #image: ${HDX_IMG_BASE}psql-gis:latest
    hostname: ${PREFIX}-${STACK}-gisdb
    container_name: ${PREFIX}-${STACK}-gisdb
    volumes:
      - "${HDX_VOL_BACKUPS}:/srv/backup"
      - "${HDX_VOL_DBS}/psql-gis:/var/lib/pgsql"
      - "${HDX_VOL_LOGS}/gis-psql:/var/log/psql"
  #  ports:
  #    - "${HDX_GISDB_ADDR}:${HDX_GISDB_PORT}:5432"
    environment:
      POSTGRESQL_DB: '${HDX_GISDB_DB}'
      POSTGRESQL_USER: '${HDX_GISDB_USER}'
      POSTGRESQL_PASS: '${HDX_GISDB_PASS}'
  #   # COMMON #
  #      TERM: 'xterm'
  #      HDX_DOMAIN: '${HDX_DOMAIN}'
  #      HDX_PREFIX: '${HDX_PREFIX}'
  #      HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
  #      HDX_TYPE: '${HDX_TYPE}'

  ################################################
  dataproxy:
    image: ${HDX_IMG_BASE}dataproxy:alpine
    #image: ${HDX_IMG_BASE}dataproxy:latest
    hostname: ${PREFIX}-${STACK}-dataproxy
    container_name: ${PREFIX}-${STACK}-dataproxy
    restart: always
  #  ports:
  #    - "${HDX_DATAPROXY_ADDR}:${HDX_DATAPROXY_PORT}:5000"
  #  extra_hosts:
  #    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  #    - "${HDX_PREFIX}manage.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  #    - "manage.${HDX_DOMAIN}: ${HDX_PROD_CPS_ADDR}"
    environment:
      # COMMON #
      TERM: 'xterm'
      HDX_DOMAIN: '${HDX_DOMAIN}'
      HDX_PREFIX: '${HDX_PREFIX}'
      HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
      HDX_TYPE: '${HDX_TYPE}'

  solr:
    image: unocha/alpine-solr:4
    #${HDX_IMG_BASE}solr:latest
    hostname: ${PREFIX}-${STACK}-solr
    container_name: ${PREFIX}-${STACK}-solr
    restart: always
    volumes:
      - "./etc/solr:/srv/solr/example/solr/ckan"
      - "${HDX_VOL_DBS}/solr:/srv/data/ckan"
  #  ports:
  #    - "${HDX_SOLR_ADDR}:${HDX_SOLR_PORT}:8983"
    environment:
      # COMMON #
      TERM: 'xterm'
      HDX_DOMAIN: '${HDX_DOMAIN}'
      HDX_PREFIX: '${HDX_PREFIX}'
      HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
      HDX_TYPE: '${HDX_TYPE}'
      # SOLR #
  #    HDX_SOLR_ADDR: '${HDX_SOLR_ADDR}'
  #    HDX_SOLR_PORT: '${HDX_SOLR_PORT}'
      IS_MASTER: '${HDX_SOLR_IS_MASTER}'
      IS_SLAVE: '${HDX_SOLR_IS_SLAVE}'

  dbckan:
    image: unocha/alpine-base-postgres:201010-PR90
    #${HDX_IMG_BASE}psql-ckan:latest
    hostname: ${PREFIX}-${STACK}-dbckan
    container_name: ${PREFIX}-${STACK}-dbckan
    restart: always
    volumes:
      - "${HDX_VOL_BACKUPS}:/srv/backup"
      - "${HDX_VOL_DBS}/psql-ckan:/var/lib/pgsql"
      - "${HDX_VOL_LOGS}/ckan-psql:/var/log/psql"
  #  ports:
  #    - "${HDX_CKANDB_ADDR}:${HDX_CKANDB_PORT}:5432"
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
    image: ${HDX_IMG_BASE}ckan:${CKAN_VERSION}
    hostname: ${PREFIX}-${STACK}-ckan
    container_name: ${PREFIX}-${STACK}-ckan
    restart: always
    volumes:
      - "${HDX_VOL_BACKUPS}:/srv/backup"
      - "${HDX_VOL_FILES}/filestore:${HDX_FILESTORE}"
      - "${HDX_VOL_LOGS}/ckan:/var/log/ckan"
  #  ports:
  #    - "${HDX_CKAN_ADDR}:${HDX_CKAN_PORT}:5000"
  #  extra_hosts:
  #    - "${HDX_PREFIX}docs.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  #    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  #    - "${HDX_PREFIX}manage.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    environment:
      # COMMON #
      TERM: 'xterm'
      HDX_DOMAIN: '${HDX_DOMAIN}'
      HDX_PREFIX: '${HDX_PREFIX}'
      HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
      HDX_TYPE: '${HDX_TYPE}'
      INI_FILE: '${INI_FILE}'
      # BACKUP_PRV #
      HDX_BACKUP_BASE_DIR: '${HDX_BACKUP_BASE_DIR}'
      HDX_BACKUP_DIR: '${HDX_BACKUP_DIR}'
      HDX_BACKUP_SERVER: '${HDX_BACKUP_SERVER}'
      HDX_BACKUP_USER: '${HDX_BACKUP_USER}'
      HDX_SSH_KEY: '${HDX_SSH_KEY}'
      HDX_SSH_PUB: '${HDX_SSH_PUB}'
      # CKAN #
  #    HDX_CKAN_ADDR: '${HDX_CKAN_ADDR}'
      HDX_CKAN_BRANCH: '${HDX_CKAN_BRANCH}'
  #    HDX_CKAN_PORT: '${HDX_CKAN_PORT}'
      HDX_FILESTORE: '${HDX_FILESTORE}'
      # CKAN_DB #
  #    HDX_CKANDB_ADDR: '${HDX_CKANDB_ADDR}'
  #    HDX_CKANDB_PORT: '${HDX_CKANDB_PORT}'
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
      HDX_MIXPANEL_TOKEN: '${HDX_MIXPANEL_TOKEN}'
      # DATAPROXY #
  #    HDX_DATAPROXY_ADDR: '${HDX_DATAPROXY_ADDR}'
  #    HDX_DATAPROXY_PORT: '${HDX_DATAPROXY_PORT}'
      # EMAIL #
  #    HDX_SMTP_ADDR: '${HDX_SMTP_ADDR}'
  #    HDX_SMTP_PORT: '${HDX_SMTP_PORT}'
      # GIS_API #
  #    HDX_GISAPI_ADDR: '${HDX_GISAPI_ADDR}'
  #    HDX_GISAPI_PORT: '${HDX_GISAPI_PORT}'
      #HDX_GISAPI_DEBUG_ADDR: '${HDX_GISAPI_DEBUG_ADDR}'
      #HDX_GISAPI_DEBUG_PORT: '${HDX_GISAPI_DEBUG_PORT}'
      # GIS_LAYER #
  #    HDX_GISLAYER_ADDR: '${HDX_GISLAYER_ADDR}'
  #    HDX_GISLAYER_PORT: '${HDX_GISLAYER_PORT}'
      # GIS_OTHER #
      HDX_GIS_TMP: '${HDX_GIS_TMP}'
      # GIS_DB #
  #    HDX_GISDB_ADDR: '${HDX_GISDB_ADDR}'
  #    HDX_GISDB_PORT: '${HDX_GISDB_PORT}'
      # GIS_REDIS #
  #    HDX_GISREDIS_ADDR: '${HDX_GISREDIS_ADDR}'
  #    HDX_GISREDIS_PORT: '${HDX_GISREDIS_PORT}'
      # GIS_DB_PRV #
      HDX_GISDB_DB: '${HDX_GISDB_DB}'
      HDX_GISDB_USER: '${HDX_GISDB_USER}'
      HDX_GISDB_PASS: '${HDX_GISDB_PASS}'
      # SOLR #
  #    HDX_SOLR_ADDR: '${HDX_SOLR_ADDR}'
  #    HDX_SOLR_PORT: '${HDX_SOLR_PORT}'
      IS_MASTER: '${HDX_SOLR_IS_MASTER}'
      IS_SLAVE: '${HDX_SOLR_IS_SLAVE}'
      # NEW RELIC #
      NEW_RELIC_APP_NAME: '${NEW_RELIC_APP_NAME}'
      NEW_RELIC_CONFIG_FILE: '${NEW_RELIC_CONFIG_FILE}'
      NEW_RELIC_ENABLED: '${NEW_RELIC_ENABLED}'
      NEW_RELIC_LICENSE_KEY: '${NEW_RELIC_LICENSE_KEY}'
      NEW_RELIC_LOG: '${NEW_RELIC_LOG}'

  ################################################

  dbcps:
    image: unocha/alpine-base-postgres:201010-PR85
    #${HDX_IMG_BASE}psql-cps:latest
    hostname: ${PREFIX}-${STACK}-dbcps
    container_name: ${PREFIX}-${STACK}-dbcps
    restart: always
    volumes:
      - "${HDX_VOL_DBS}/psql-cps:/var/lib/pgsql"

  cps:
    #image: ${HDX_IMG_BASE}cps:v0.15.1
    image: ${HDX_IMG_BASE}cps:v0.15.1-alpine
    hostname: ${PREFIX}-${STACK}-cps
    container_name: ${PREFIX}-${STACK}-cps
    restart: always
    volumes:
      - "${HDX_VOL_BACKUPS}:/srv/backup"
      - "${HDX_VOL_LOGS}/cps/cps:${HDX_FOLDER}/logs"
      - "${HDX_VOL_LOGS}/cps/tomcat:/srv/tomcat/logs"
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
      # CPS_DB_PRV #
      HDX_CPSDB_DB: '${HDX_CPSDB_DB}'
      HDX_CPSDB_PASS: '${HDX_CPSDB_PASS}'
      HDX_CPSDB_USER: '${HDX_CPSDB_USER}'
#      VIRTUAL_HOST: 'bm-manage.humdata.org'
#      VIRTUAL_PORT: '8080'
#      VIRTUAL_NETWORK: 'nginx-proxy'
#      LETSENCRYPT_HOST: 'bm-manage.humdata.org'
#      LETSENCRYPT_EMAIL: 'ops+hrinfo@humanitarianresponse.info'
    networks:
      default:
        aliases:
          - manage.hdx.rwlabs.org
#      proxy:

  web-cps:
    image: ${HDX_IMG_BASE}nginx:latest
    hostname: ${PREFIX}-${STACK}-web-cps
    container_name: ${PREFIX}-${STACK}-web-cps
    restart: always
    volumes:
      - "./etc/nginx-cps:/etc/nginx"
      - "${HDX_VOL_FILES}/www:/srv/www"
      - "${HDX_VOL_LOGS}/nginx:/var/log/nginx"
  #  ports:
  #    - "${HDX_WB_ADDR}:${HDX_HTTP_PORT}:80"
  #    - "${HDX_WB_ADDR}:${HDX_HTTPS_PORT}:443"
    environment:
      # COMMON #
      TERM: 'xterm'
      HDX_DOMAIN: '${HDX_DOMAIN}'
      HDX_PREFIX: '${HDX_PREFIX}'
      HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
      HDX_TYPE: '${HDX_TYPE}'
      # WEB #
      HDX_HTTPS_REDIRECT: '${HDX_HTTPS_REDIRECT}'
      HDX_HTTPS_REDIRECT_ON_PROTO_HEADER: '${HDX_HTTPS_REDIRECT_ON_PROTO_HEADER}'
      #VIRTUAL_HOST: '${VIRTUAL_HOST}'
      VIRTUAL_HOST: '${HDX_PREFIX}manage.${HDX_DOMAIN}'
      VIRTUAL_PORT: '80'
      VIRTUAL_NETWORK: 'nginx-proxy'
      LETSENCRYPT_HOST: '${HDX_PREFIX}manage.${HDX_DOMAIN}'
      LETSENCRYPT_EMAIL: 'ops+hrinfo@humanitarianresponse.info'
    networks:
      default:
      proxy:



  ################################################

  dbblog:
    image: unocha/alpine-mysql
    #${HDX_IMG_BASE}mysql:latest
    hostname: ${PREFIX}-${STACK}-dbblog
    container_name: ${PREFIX}-${STACK}-dbblog
    restart: always
    volumes:
      - "${HDX_VOL_DBS}/mysql:/srv/db"
      - "${HDX_VOL_LOGS}/mysql-blog:${HDX_FOLDER}/mysql"
  #  ports:
  #    - "${HDX_BLOGDB_ADDR}:${HDX_BLOGDB_PORT}:3306"
    environment:
      # COMMON #
      TERM: 'xterm'
      HDX_DOMAIN: '${HDX_DOMAIN}'
      HDX_PREFIX: '${HDX_PREFIX}'
      HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
      HDX_TYPE: '${HDX_TYPE}'
      MYSQL_DIR: '/srv/db'
      MYSQL_DB: '${HDX_BLOGDB_DB}'
      MYSQL_USER: '${HDX_BLOGDB_USER}'
      MYSQL_PASS: '${HDX_BLOGDB_PASS}'

  blog:
    image: ${HDX_IMG_BASE}blog:latest
    hostname: ${PREFIX}-${STACK}-blog
    container_name: ${PREFIX}-${STACK}-blog
    restart: always
  #  ports:
  #    - "${HDX_BLOG_ADDR}:${HDX_BLOG_PORT}:9000"
    volumes:
      - "${HDX_VOL_BACKUPS}:/srv/backup"
      - "${HDX_VOL_FILES}/www/docs:/srv/www/docs"
      - "${HDX_VOL_LOGS}/blog:${HDX_FOLDER}/blog"
  #  extra_hosts:
  #    - "${HDX_PREFIX}docs.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  #    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  #    - "${HDX_PREFIX}manage.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  #    - "${HDX_BLOGDB_ADDR}: db"
    environment:
      # COMMON #
      TERM: 'xterm'
      HDX_DOMAIN: '${HDX_DOMAIN}'
      HDX_PREFIX: '${HDX_PREFIX}'
      HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
      HDX_TYPE: '${HDX_TYPE}'
      # BLOG #
  #    HDX_BLOG_ADDR: '${HDX_BLOG_ADDR}'
      HDX_BLOG_DIR: '${HDX_BLOG_DIR}'
  #    HDX_BLOG_PORT: '${HDX_BLOG_PORT}'
      # BACKUP_PRV #
      HDX_BACKUP_BASE_DIR: '${HDX_BACKUP_BASE_DIR}'
      HDX_BACKUP_DIR: '${HDX_BACKUP_DIR}'
      HDX_BACKUP_SERVER: '${HDX_BACKUP_SERVER}'
      HDX_BACKUP_USER: '${HDX_BACKUP_USER}'
      HDX_SSH_KEY: '${HDX_SSH_KEY}'
      HDX_SSH_PUB: '${HDX_SSH_PUB}'
      # BLOG_DB #
  #    HDX_BLOGDB_ADDR: '${HDX_BLOGDB_ADDR}'
  #    HDX_BLOGDB_PORT: '${HDX_BLOGDB_PORT}'
      # BLOG_DB_PRV #
      HDX_BLOGDB_DB: '${HDX_BLOGDB_DB}'
      HDX_BLOGDB_USER: '${HDX_BLOGDB_USER}'
      HDX_BLOGDB_PASS: '${HDX_BLOGDB_PASS}'


  web-blog:
    image: ${HDX_IMG_BASE}nginx:latest
    hostname: ${PREFIX}-${STACK}-web-blog
    container_name: ${PREFIX}-${STACK}-web-blog
    restart: always
    volumes:
      - "./etc/nginx-blog:/etc/nginx"
      - "${HDX_VOL_FILES}/www:/srv/www"
      - "${HDX_VOL_LOGS}/nginx:/var/log/nginx"
  #  ports:
  #    - "${HDX_WB_ADDR}:${HDX_HTTP_PORT}:80"
  #    - "${HDX_WB_ADDR}:${HDX_HTTPS_PORT}:443"
    environment:
      # COMMON #
      TERM: 'xterm'
      HDX_DOMAIN: '${HDX_DOMAIN}'
      HDX_PREFIX: '${HDX_PREFIX}'
      HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
      HDX_TYPE: '${HDX_TYPE}'
      # BLOG #
  #    HDX_BLOG_ADDR: '${HDX_BLOG_ADDR}'
      HDX_BLOG_DIR: '${HDX_BLOG_DIR}'
  #    HDX_BLOG_PORT: '${HDX_BLOG_PORT}'
      # WEB #
      HDX_HTTPS_REDIRECT: '${HDX_HTTPS_REDIRECT}'
      HDX_HTTPS_REDIRECT_ON_PROTO_HEADER: '${HDX_HTTPS_REDIRECT_ON_PROTO_HEADER}'
      #VIRTUAL_HOST: '${VIRTUAL_HOST}'
      # WEB_PRV #
      HDX_NGINX_PASS: '${HDX_NGINX_PASS}'
      HDX_SSL_CRT: '${HDX_SSL_CRT}'
      HDX_SSL_KEY: '${HDX_SSL_KEY}'
      HDX_USER_AGENT: '${HDX_USER_AGENT}'
      VIRTUAL_HOST: '${HDX_PREFIX}docs.${HDX_DOMAIN}'
      VIRTUAL_PORT: '80'
      VIRTUAL_NETWORK: 'nginx-proxy'
      LETSENCRYPT_HOST: '${HDX_PREFIX}docs.${HDX_DOMAIN}'
      LETSENCRYPT_EMAIL: 'ops+hrinfo@humanitarianresponse.info'
    networks:
      default:
      proxy:


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
  #  extra_hosts:
  #    - "${HDX_PREFIX}docs.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  #    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  #    - "${HDX_PREFIX}manage.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    environment:
      # COMMON #
      TERM: 'xterm'
      HDX_DOMAIN: '${HDX_DOMAIN}'
      HDX_PREFIX: '${HDX_PREFIX}'
      HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
      HDX_TYPE: '${HDX_TYPE}'
      # BLOG #
  #    HDX_BLOG_ADDR: '${HDX_BLOG_ADDR}'
      HDX_BLOG_DIR: '${HDX_BLOG_DIR}'
  #    HDX_BLOG_PORT: '${HDX_BLOG_PORT}'
      # BACKUP_PRV #
      HDX_BACKUP_BASE_DIR: '${HDX_BACKUP_BASE_DIR}'
      HDX_BACKUP_DIR: '${HDX_BACKUP_DIR}'
      HDX_BACKUP_SERVER: '${HDX_BACKUP_SERVER}'
      HDX_BACKUP_USER: '${HDX_BACKUP_USER}'
      HDX_SSH_KEY: '${HDX_SSH_KEY}'
      HDX_SSH_PUB: '${HDX_SSH_PUB}'
      # BLOG_DB #
  #    HDX_BLOGDB_ADDR: '${HDX_BLOGDB_ADDR}'
  #    HDX_BLOGDB_PORT: '${HDX_BLOGDB_PORT}'
      # BLOG_DB_PRV #
      HDX_BLOGDB_DB: '${HDX_BLOGDB_DB}'
      HDX_BLOGDB_USER: '${HDX_BLOGDB_USER}'
      HDX_BLOGDB_PASS: '${HDX_BLOGDB_PASS}'
      # CKAN #
  #    HDX_CKAN_ADDR: '${HDX_CKAN_ADDR}'
      HDX_CKAN_BRANCH: '${HDX_CKAN_BRANCH}'
  #    HDX_CKAN_PORT: '${HDX_CKAN_PORT}'
      HDX_FILESTORE: '${HDX_FILESTORE}'
      # CKAN_DB #
  #    HDX_CKANDB_ADDR: '${HDX_CKANDB_ADDR}'
  #    HDX_CKANDB_PORT: '${HDX_CKANDB_PORT}'
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
  #    HDX_CPS_ADDR: '${HDX_CPS_ADDR}'
      HDX_CPS_BRANCH: '${HDX_CPS_BRANCH}'
  #    HDX_CPS_PORT: '${HDX_CPS_PORT}'
      # CPS_PROD_IP #
  #    HDX_PROD_CPS_ADDR: '${HDX_PROD_CPS_ADDR}'
      # CPS_OTHER #
      HDX_FOLDER: '${HDX_FOLDER}'
      # CPS_DB #
  #    HDX_CPSDB_ADDR: '${HDX_CPSDB_ADDR}'
  #    HDX_CPSDB_PORT: '${HDX_CPSDB_PORT}'
      # CPS_DB_PRV #
      HDX_CPSDB_DB: '${HDX_CPSDB_DB}'
      HDX_CPSDB_PASS: '${HDX_CPSDB_PASS}'
      HDX_CPSDB_USER: '${HDX_CPSDB_USER}'
      # DATAPROXY #
  #    HDX_DATAPROXY_ADDR: '${HDX_DATAPROXY_ADDR}'
  #    HDX_DATAPROXY_PORT: '${HDX_DATAPROXY_PORT}'
      # EMAIL #
  #    HDX_SMTP_ADDR: '${HDX_SMTP_ADDR}'
  #    HDX_SMTP_PORT: '${HDX_SMTP_PORT}'
      # EMAIL_PRV #
  #    HDX_DKIM_CRT: '${HDX_DKIM_CRT}'
  #    HDX_DKIM_KEY: '${HDX_DKIM_KEY}'
      # GIS_API #
  #    HDX_GISAPI_ADDR: '${HDX_GISAPI_ADDR}'
  #    HDX_GISAPI_PORT: '${HDX_GISAPI_PORT}'
      #HDX_GISAPI_DEBUG_ADDR: '${HDX_GISAPI_DEBUG_ADDR}'
      #HDX_GISAPI_DEBUG_PORT: '${HDX_GISAPI_DEBUG_PORT}'
      # GIS_LAYER #
  #    HDX_GISLAYER_ADDR: '${HDX_GISLAYER_ADDR}'
  #    HDX_GISLAYER_PORT: '${HDX_GISLAYER_PORT}'
      # GIS_OTHER #
      HDX_GIS_TMP: '${HDX_GIS_TMP}'
      # GIS_DB #
  #    HDX_GISDB_ADDR: '${HDX_GISDB_ADDR}'
  #    HDX_GISDB_PORT: '${HDX_GISDB_PORT}'
      # GIS_REDIS #
  #    HDX_GISREDIS_ADDR: '${HDX_GISREDIS_ADDR}'
  #    HDX_GISREDIS_PORT: '${HDX_GISREDIS_PORT}'
      # GIS_DB_PRV #
      HDX_GISDB_DB: '${HDX_GISDB_DB}'
      HDX_GISDB_USER: '${HDX_GISDB_USER}'
      HDX_GISDB_PASS: '${HDX_GISDB_PASS}'
      # GIS_PRV #
      HDX_GIS_API_KEY: '${HDX_GIS_API_KEY}'
      # SOLR #
  #    HDX_SOLR_ADDR: '${HDX_SOLR_ADDR}'
  #    HDX_SOLR_PORT: '${HDX_SOLR_PORT}'
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
  #  extra_hosts:
  #    - "${HDX_PREFIX}docs.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  #    - "${HDX_PREFIX}data.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
  #    - "${HDX_PREFIX}manage.${HDX_DOMAIN}: ${HDX_WB_ADDR}"
    environment:
      # COMMON #
      TERM: 'xterm'
      HDX_DOMAIN: '${HDX_DOMAIN}'
      HDX_PREFIX: '${HDX_PREFIX}'
      HDX_SHORT_PREFIX: '${HDX_SHORT_PREFIX}'
      HDX_TYPE: '${HDX_TYPE}'
      # CKAN #
  #    HDX_CKAN_ADDR: '${HDX_CKAN_ADDR}'
      HDX_CKAN_BRANCH: '${HDX_CKAN_BRANCH}'
  #    HDX_CKAN_PORT: '${HDX_CKAN_PORT}'
      HDX_FILESTORE: '${HDX_FILESTORE}'
      # CKAN_DB #
  #    HDX_CKANDB_ADDR: '${HDX_CKANDB_ADDR}'
  #    HDX_CKANDB_PORT: '${HDX_CKANDB_PORT}'
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
