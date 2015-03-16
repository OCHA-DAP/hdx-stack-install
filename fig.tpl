# copyleft 2015 teodorescu.serban@gmail.com

################################################

web:
  image: ${HDX_IMG_BASE}nginx:latest
  volumes:
     - "${HDX_BASE_VOL_PATH}/www:/srv/www"
     - "/var/log/nginx:/var/log/nginx"
  ports:
    - "${HDX_HTTP_PORT}:80"
    - "${HDX_HTTPS_PORT}:443"
  environment:
    - HDX_DOMAIN=${HDX_DOMAIN}
    - HDX_PREFIX=${HDX_PREFIX}
    - HDX_SSL_KEY=${HDX_SSL_KEY}
    - HDX_BLOG_ADDR=${HDX_BLOG_ADDR}
    - HDX_BLOG_PORT=${HDX_BLOG_PORT}
    - HDX_CKAN_ADDR=${HDX_CKAN_ADDR}
    - HDX_CKAN_PORT=${HDX_CKAN_PORT}
    - HDX_CPS_ADDR=${HDX_CPS_ADDR}
    - HDX_CPS_PORT=${HDX_CPS_PORT}
    - HDX_DATAPROXY_ADDR=${HDX_DATAPROXY_ADDR}
    - HDX_DATAPROXY_PORT=${HDX_DATAPROXY_PORT}

################################################

email:
  image: ${HDX_IMG_BASE}email:latest
  ports:
    - "${HDX_SMTP_ADDR}:${HDX_SMTP_PORT}:25"
  environment:
    - HDX_DKIM_KEY=${HDX_DKIM_KEY}


################################################

dataproxy:
  image: ${HDX_IMG_BASE}dataproxy:latest
  ports:
    - "${HDX_DATAPROXY_ADDR}:${HDX_DATAPROXY_PORT}:9223"

ogre:
  image: ${HDX_IMG_BASE}ogre:latest
  ports:
    - "${HDX_OGRE_ADDR}:${HDX_OGRE_PORT}:3000"

solr:
  image: ${HDX_IMG_BASE}solr:latest
  volumes:
    - "${HDX_BASE_VOL_PATH}/solr:/srv/solr/example/solr/ckan/data"

dbckan:
  image: ${HDX_IMG_BASE}psql-ckan:latest
  volumes:
    - "${HDX_BASE_VOL_PATH}/psql-ckan:/srv/db"

ckan:
  image: ${HDX_IMG_BASE}ckan:latest
  links:
    - dbckan:db
    - solr
  volumes:
    - "${HDX_BASE_VOL_PATH}/backup:/srv/backup"
    - "${HDX_BASE_VOL_PATH}/filestore:/srv/filestore"
    - "/var/log/ckan:/var/log/ckan"
  ports:
    - "${HDX_CKAN_ADDR}:${HDX_CKAN_PORT}:9221"
  environment:
    - HDX_CKAN_BRANCH=${HDX_CKAN_BRANCH}
    - HDX_TYPE=${HDX_TYPE}
    - HDX_DOMAIN=${HDX_DOMAIN}
    - HDX_PREFIX=${HDX_PREFIX}
    - HDX_FILESTORE=/srv/filestore
    - HDX_CKAN_RECAPTCHA_KEY=${HDX_CKAN_RECAPTCHA_KEY}
    - HDX_BACKUP_SERVER=${HDX_BACKUP_SERVER}
    - HDX_BACKUP_USER=${HDX_BACKUP_USER}
    - HDX_BACKUP_BASE_DIR=${HDX_BACKUP_BASE_DIR}
    - HDX_SSH_KEY=${HDX_SSH_KEY}
    - HDX_SSH_PUB=${HDX_SSH_PUB}
################################################

dbcps:
  image: ${HDX_IMG_BASE}psql-cps:latest
  volumes:
    - "${HDX_BASE_VOL_PATH}/psql-cps:/srv/db"

cps:
  image: ${HDX_IMG_BASE}cps:latest
  links:
    - dbcps:db
  ports:
    - "${HDX_CPS_ADDR}:${HDX_CPS_PORT}:8080"
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
  volumes:
    - "${HDX_BASE_VOL_PATH}/mysql:/srv/db"

blog:
  image: ${HDX_IMG_BASE}blog:latest
  links:
    - dbblog:db
  ports:
    - "${HDX_BLOG_ADDR}:${HDX_BLOG_PORT}:9000"
  volumes:
    - "${HDX_BASE_VOL_PATH}/www/docs:/srv/www/docs"
  environment:
    - HDX_DOMAIN=${HDX_DOMAIN}
    - HDX_PREFIX=${HDX_PREFIX}
    - HDX_BACKUP_SERVER=${HDX_BACKUP_SERVER}
    - HDX_BACKUP_USER=${HDX_BACKUP_USER}
    - HDX_BACKUP_BASE_DIR=${HDX_BACKUP_BASE_DIR}
    - HDX_SSH_KEY=${HDX_SSH_KEY}
    - HDX_SSH_PUB=${HDX_SSH_PUB}

################################################
