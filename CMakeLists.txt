cmake_minimum_required(VERSION 2.6)
project(unref CXX)
#set (CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
#set (CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

option(BUILD_EXECUTABLE "Enable unref executable" ON)
option(EXTERNAL_LIBPROJ "Use external libproj" OFF)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)


add_library(libunref unref.cpp HilbertCurve.cpp delaunaySphere.cpp
robustPredicates.cpp delaunay_refinement.cpp edge_recovery.cpp
quadSplash.cpp vertexFilter.cpp shp.cpp unrefTimer.cpp)
set_target_properties(libunref PROPERTIES OUTPUT_NAME unref)

add_definitions(${OPENMP_CXX_FLAGS})
target_link_libraries(libunref m ${PROJ_LIB}) 

include(ExternalProject)
if(EXTERNAL_LIBPROJ)
  find_library(PROJ_LIB proj)
  find_path(PROJ_INCLUDE_PATH "proj_api.h")
else()
  ExternalProject_Add(proj
    URL http://download.osgeo.org/proj/proj-4.9.2.tar.gz
    CMAKE_ARGS
    -DCMAKE_BUILD_TYPE=Release
    -DUSE_THREAD=OFF
    -DBUILD_GEOD=OFF
    -DBUILD_NAD2BIN=OFF
    -DBUILD_CS2CS=OFF
    -DBUILD_LIBPROJ_SHARED=OFF
    -DBUILD_TESTING=OFF
    -DBUILD_PROJ=OFF
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
    -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/proj
    PREFIX proj
    BINARY_DIR proj/build
    )
  set(PROJ_LIB ${CMAKE_CURRENT_BINARY_DIR}/proj/lib/libproj.a)
  set(PROJ_INCLUDE_PATH ${CMAKE_CURRENT_BINARY_DIR}/proj/include)
endif()
include_directories(${PROJ_INCLUDE_PATH})

if(BUILD_EXECUTABLE)
  ExternalProject_Add(flann
    URL http://www.cs.ubc.ca/research/flann/uploads/FLANN/flann-1.8.4-src.zip
    URL_MD5 a0ecd46be2ee11a68d2a7d9c6b4ce701
    PREFIX flann
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    )

  include_directories(${CMAKE_CURRENT_BINARY_DIR}/flann/src/flann/src/cpp)
  add_executable(unref main.cpp)
  target_link_libraries(unref libunref m ${PROJ_LIB}) 
  add_dependencies(unref flann)
  if(NOT EXTERNAL_LIBPROJ)
    add_dependencies(unref proj)
  endif(NOT EXTERNAL_LIBPROJ)
endif(BUILD_EXECUTABLE)

#set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -stdlib=libc++ -lc++abi")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++ -lc++abi")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
