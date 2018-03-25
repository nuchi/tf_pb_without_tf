#!/usr/bin/env bash

set -e

TF_URL="https://github.com/tensorflow/tensorflow.git"
TF_SERVING_URL="https://github.com/tensorflow/serving.git"
TF_COMMIT="r1.6"

# Retrieve tensorflow and tensorflow_serving repos
mkdir -p scratch
cd scratch
git clone -b "$TF_COMMIT" "$TF_URL"
git clone -b "$TF_COMMIT" "$TF_SERVING_URL"
cd ..

# Reorganize contents to make it easy to compile protos.
# This way the final results will have correct relative paths
# to each other.
mkdir -p workspace
mv scratch/tensorflow/tensorflow workspace/
mv scratch/serving/tensorflow_serving workspace/

# Install prerequisite packages
python -m pip install virtualenv
virtualenv venv
source venv/bin/activate
pip install --upgrade pip wheel protobuf grpcio grpcio-tools

# Create the python package of pb2 interfaces
mkdir -p tf_pb
cd workspace
## Compile protobufs
find . -name '*.proto' -exec \
  python -m grpc_tools.protoc -I./ \
    --python_out=../tf_pb/ \
    --grpc_python_out=../tf_pb/ \
    {} ';'
## Add __init__.py's to make it a package. First one is special.
## Read it and modify it to your taste.
cd ../tf_pb
cp ../sample__init__.py ./__init__.py
find . -type d -exec touch {}/__init__.py ';'

# Build the package
cd ..
python setup.py bdist_wheel

# Voila! Your wheel is at ./dist/tf_pb-0.0.0-py2-none-any.whl
