# copyleft 2015 teodorescu.serban@gmail.com

################################################


version: "2"

networks:
  proxy:
    external:
      name: nginx-proxy

services:
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

  cps-web:
    #image: ${HDX_IMG_BASE}nginx:latest
    image: unocha/alpine-nginx-extras:201610-PR95
    hostname: ${PREFIX}-${STACK}-cps-web
    container_name: ${PREFIX}-${STACK}-cps-web
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

