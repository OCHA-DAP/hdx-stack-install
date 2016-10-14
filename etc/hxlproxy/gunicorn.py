bind = '0.0.0.0:5000'
workers = 4
access_log_format = '"%({x-forwarded-for}i)s" %(l)s %(u)s %(t)s "%(r)s" %(s)s %(b)s "%(f)s" "%(a)s"'
accesslog = '/var/log/proxy/proxy.access.log'
errorlog = '/var/log/proxy/proxy.error.log'
loglevel = 'warning'
timeout = 120
graceful_timeout = 90
