import setuptools

setuptools.setup(
  name='tf_pb',
  packages=setuptools.find_packages('.'),
  install_requires=['protobuf', 'grpcio']
)
