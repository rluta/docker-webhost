# Make sure env variables are started

export LOCAL_HOST=${LOCAL_HOST:-proxy.aptiwan.com}
export REMOTE_HOST=${REMOTE_HOST:-demo.aptiwan.com}

apache2ctl start
