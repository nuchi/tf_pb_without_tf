import os
import sys
"""
Whyyyy??? Because of the way the protobufs are compiled, they all contain
imports like eg `from tensorflow.core.framework.tensor_pb2 import TensorProto`.
Adding this file's directory to sys.path means that we can just leave the files
where they are, without modifying them, and they'll just find each other when
they need to import one another. For safety I've added a bunch of imports to
this file so that later I can just do `from tf_pb import TensorProto` etc.
"""
dir_path = os.path.dirname(__file__)
old_sys_path = sys.path
sys.path = [dir_path] + old_sys_path


# Add or remove any to suit your purpose. These are for convenient default
# signature prediction requests.
from tensorflow_serving.apis.predict_pb2 import PredictRequest
from tensorflow_serving.apis.predict_pb2 import PredictResponse
from tensorflow_serving.apis.prediction_service_pb2_grpc import PredictionServiceStub
from tensorflow.core.framework.tensor_pb2 import TensorProto
from tensorflow.core.framework.tensor_shape_pb2 import TensorShapeProto
Dim = TensorShapeProto.Dim
from tensorflow.core.framework.types_pb2 import DT_FLOAT

sys.path = old_sys_path
