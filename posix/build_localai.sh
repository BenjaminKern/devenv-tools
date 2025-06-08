#!/bin/bash

INSTALL_PREFIX="$(pwd)/install"

git clone --recurse-submodules -b v1.73.0 --depth 1 --shallow-submodules https://github.com/grpc/grpc.git
cmake -Sgrpc -Bbuild_grpc \
  -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
  -DCMAKE_BUILD_TYPE=Release \
  -DgRPC_INSTALL=ON \
  -DCMAKE_CXX_STANDARD=17 \
  -DgRPC_BUILD_TESTS=OFF \
  -GNinja \
  -DgRPC_BUILD_GRPC_CPP_PLUGIN=ON \
  -DgRPC_BUILD_GRPC_PYTHON_PLUGIN=ON \
  -DgRPC_BUILD_GRPC_CSHARP_PLUGIN=OFF \
  -DgRPC_BUILD_GRPC_NODE_PLUGIN=OFF \
  -DgRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN=OFF \
  -DgRPC_BUILD_GRPC_PHP_PLUGIN=OFF \
  -DgRPC_BUILD_GRPC_RUBY_PLUGIN=OFF \
  -DBUILD_SHARED_LIBS=OFF

cmake --build build_grpc
cmake --install build_grpc

## 4d282ca9
# git clone https://github.com/go-skynet/LocalAI.git
# cd LocalAI && make dist (--> check release folder)

# NOTE:
# - Add INSTALL_PREFIX to CMAKE_PREFIX_PATH
# - Make sure, ninja, and cmake are available
# - Make sure ~/go/bin is available PATH
# - Make sure $INSTALL_PREFIX/bin is available in PATH (protoc)
# - Fix whisper go bindings build (on OSX) by removing -fopenmp from
#   sources/whisper.cpp/bindings/go/whisper.go
#   --> #cgo LDFLAGS: -lwhisper -lggml -lggml-base -lggml-cpu  -lm -lstdc++
# - Fix localai grpc-server build by doing by adding the patch.
    # diff --git a/backend/cpp/llama/CMakeLists.txt b/backend/cpp/llama/CMakeLists.txt
    # index c839800b..cb91df66 100644
    # --- a/backend/cpp/llama/CMakeLists.txt
    # +++ b/backend/cpp/llama/CMakeLists.txt
    # @@ -2,7 +2,6 @@ set(TARGET grpc-server)
    #  set(CMAKE_CXX_STANDARD 17)
    # cmake_minimum_required(VERSION 3.15)
    # set(TARGET grpc-server)
    #-set(_PROTOBUF_LIBPROTOBUF libprotobuf)
    # set(_REFLECTION grpc++_reflection)
    # 
    # if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    #@@ -18,10 +17,9 @@ if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    # endif()
    # 
    # find_package(absl CONFIG REQUIRED)
    #-find_package(Protobuf CONFIG REQUIRED)
    #+find_package(protobuf CONFIG REQUIRED)
    # find_package(gRPC CONFIG REQUIRED)
    # 
    #-find_program(_PROTOBUF_PROTOC protoc)
    # set(_GRPC_GRPCPP grpc++)
    # find_program(_GRPC_CPP_PLUGIN_EXECUTABLE grpc_cpp_plugin)
    # 
    #@@ -42,7 +40,7 @@ set(hw_grpc_hdrs "${CMAKE_CURRENT_BINARY_DIR}/backend.grpc.pb.h")
    # 
    # add_custom_command(
    #       OUTPUT "${hw_proto_srcs}" "${hw_proto_hdrs}" "${hw_grpc_srcs}" "${hw_grpc_hdrs}"
    #-      COMMAND ${_PROTOBUF_PROTOC}
    #+      COMMAND protobuf::protoc
    #       ARGS --grpc_out "${CMAKE_CURRENT_BINARY_DIR}"
    #         --cpp_out "${CMAKE_CURRENT_BINARY_DIR}"
    #         -I "${hw_proto_path}"
    #@@ -57,6 +55,10 @@ add_library(hw_grpc_proto
    #   ${hw_proto_srcs}
    #   ${hw_proto_hdrs} )
    # 
    #+target_link_libraries(hw_grpc_proto
    #+  protobuf::libprotobuf
    #+)
    #+
    # add_executable(${TARGET} grpc-server.cpp utils.hpp json.hpp httplib.h)
    # 
    # target_include_directories(${TARGET} PRIVATE ../llava)
    #@@ -65,9 +67,8 @@ target_include_directories(${TARGET} PRIVATE ${CMAKE_SOURCE_DIR})
    # target_link_libraries(${TARGET} PRIVATE common llama mtmd ${CMAKE_THREAD_LIBS_INIT} absl::flags hw_grpc_proto
    #   absl::flags_parse
    #   gRPC::${_REFLECTION}
    #-  gRPC::${_GRPC_GRPCPP}
    #-  protobuf::${_PROTOBUF_LIBPROTOBUF})
    #+  gRPC::${_GRPC_GRPCPP})
    # target_compile_features(${TARGET} PRIVATE cxx_std_11)
    # if(TARGET BUILD_INFO)
    #   add_dependencies(${TARGET} BUILD_INFO)
    #-endif()
    #\ No newline at end of file
    #+endif()
