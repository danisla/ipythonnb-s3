#!/bin/bash

if [[ -z "$AWS_ACCESS_KEY_ID" ]]; then
  echo "ERROR: AWS_ACCESS_KEY_ID is not set."
  exit 1
fi

if [[ -z "$AWS_SECRET_ACCESS_KEY" ]]; then
  echo "ERROR: AWS_SECRET_ACCESS_KEY is not set."
  exit 1
fi

if [[ -z "$S3_BUCKET" ]]; then
  echo "ERROR: S3_BUCKET is not set."
  exit 1
fi

if [[ -z "$S3_PREFIX" ]]; then
  echo "ERROR: S3_PREFIX is not set."
  exit 1
fi

S3_HOST=${S3_HOST:-"s3.amazonaws.com"}

TIMESTAMP=`date`

if [[ ! -d ${HOME}/.ipython ]]; then
  mkdir -p ${HOME}/.ipython
fi

echo "INFO: Creating profile nbserver"

ipython profile create nbserver

cat - >> ${HOME}/.ipython/profile_nbserver/ipython_config.py <<EOF
# Generated by container start.sh at $TIMESTAMP

c.NotebookApp.notebook_manager_class = 's3nbmanager.S3NotebookManager'
c.S3NotebookManager.aws_access_key_id = '$AWS_ACCESS_KEY_ID'
c.S3NotebookManager.aws_secret_access_key = '$AWS_SECRET_ACCESS_KEY'
c.S3NotebookManager.s3_bucket = '$S3_BUCKET'
c.S3NotebookManager.s3_prefix = '$S3_PREFIX'
c.S3NotebookManager.s3_host = '$S3_HOST'
EOF

# Start the server
PORT=${PORT0:-8888}
echo "INFO: Starting notebook server on port $PORT, saving notebooks to s3://${S3_BUCKET}/${S3_PREFIX}"

ipython notebook --port=$PORT --profile=nbserver
