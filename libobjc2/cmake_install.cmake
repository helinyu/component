# Install script for directory: /Users/xiaoniu/Desktop/libobjc2

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/objdump")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/Users/xiaoniu/Desktop/libobjc2/libobjc.4.6.dylib")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libobjc.4.6.dylib" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libobjc.4.6.dylib")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" -x "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libobjc.4.6.dylib")
    endif()
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/Users/xiaoniu/Desktop/libobjc2/libobjc.dylib")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libobjc.dylib" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libobjc.dylib")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" -x "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libobjc.dylib")
    endif()
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/objc" TYPE FILE FILES
    "/Users/xiaoniu/Desktop/libobjc2/objc/Availability.h"
    "/Users/xiaoniu/Desktop/libobjc2/objc/Object.h"
    "/Users/xiaoniu/Desktop/libobjc2/objc/Protocol.h"
    "/Users/xiaoniu/Desktop/libobjc2/objc/blocks_private.h"
    "/Users/xiaoniu/Desktop/libobjc2/objc/blocks_runtime.h"
    "/Users/xiaoniu/Desktop/libobjc2/objc/capabilities.h"
    "/Users/xiaoniu/Desktop/libobjc2/objc/developer.h"
    "/Users/xiaoniu/Desktop/libobjc2/objc/encoding.h"
    "/Users/xiaoniu/Desktop/libobjc2/objc/hooks.h"
    "/Users/xiaoniu/Desktop/libobjc2/objc/message.h"
    "/Users/xiaoniu/Desktop/libobjc2/objc/objc-api.h"
    "/Users/xiaoniu/Desktop/libobjc2/objc/objc-arc.h"
    "/Users/xiaoniu/Desktop/libobjc2/objc/objc-auto.h"
    "/Users/xiaoniu/Desktop/libobjc2/objc/objc-class.h"
    "/Users/xiaoniu/Desktop/libobjc2/objc/objc-runtime.h"
    "/Users/xiaoniu/Desktop/libobjc2/objc/objc-visibility.h"
    "/Users/xiaoniu/Desktop/libobjc2/objc/objc.h"
    "/Users/xiaoniu/Desktop/libobjc2/objc/runtime-deprecated.h"
    "/Users/xiaoniu/Desktop/libobjc2/objc/runtime.h"
    "/Users/xiaoniu/Desktop/libobjc2/objc/slot.h"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES
    "/Users/xiaoniu/Desktop/libobjc2/Block.h"
    "/Users/xiaoniu/Desktop/libobjc2/Block_private.h"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/Users/xiaoniu/Desktop/libobjc2/libobjc.pc")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/Users/xiaoniu/Desktop/libobjc2/Test/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/Users/xiaoniu/Desktop/libobjc2/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
