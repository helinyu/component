# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.21

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/Cellar/cmake/3.21.2/bin/cmake

# The command to remove a file.
RM = /usr/local/Cellar/cmake/3.21.2/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/xiaoniu/Desktop/libobjc2

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/xiaoniu/Desktop/libobjc2

# Include any dependencies generated for this target.
include Test/CMakeFiles/ARCTest_arc.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include Test/CMakeFiles/ARCTest_arc.dir/compiler_depend.make

# Include the progress variables for this target.
include Test/CMakeFiles/ARCTest_arc.dir/progress.make

# Include the compile flags for this target's objects.
include Test/CMakeFiles/ARCTest_arc.dir/flags.make

Test/CMakeFiles/ARCTest_arc.dir/ARCTest_arc.m.o: Test/CMakeFiles/ARCTest_arc.dir/flags.make
Test/CMakeFiles/ARCTest_arc.dir/ARCTest_arc.m.o: Test/ARCTest_arc.m
Test/CMakeFiles/ARCTest_arc.dir/ARCTest_arc.m.o: Test/CMakeFiles/ARCTest_arc.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/xiaoniu/Desktop/libobjc2/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object Test/CMakeFiles/ARCTest_arc.dir/ARCTest_arc.m.o"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -Xclang -fobjc-arc -MD -MT Test/CMakeFiles/ARCTest_arc.dir/ARCTest_arc.m.o -MF CMakeFiles/ARCTest_arc.dir/ARCTest_arc.m.o.d -o CMakeFiles/ARCTest_arc.dir/ARCTest_arc.m.o -c /Users/xiaoniu/Desktop/libobjc2/Test/ARCTest_arc.m

Test/CMakeFiles/ARCTest_arc.dir/ARCTest_arc.m.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/ARCTest_arc.dir/ARCTest_arc.m.i"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -Xclang -fobjc-arc -E /Users/xiaoniu/Desktop/libobjc2/Test/ARCTest_arc.m > CMakeFiles/ARCTest_arc.dir/ARCTest_arc.m.i

Test/CMakeFiles/ARCTest_arc.dir/ARCTest_arc.m.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/ARCTest_arc.dir/ARCTest_arc.m.s"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -Xclang -fobjc-arc -S /Users/xiaoniu/Desktop/libobjc2/Test/ARCTest_arc.m -o CMakeFiles/ARCTest_arc.dir/ARCTest_arc.m.s

# Object files for target ARCTest_arc
ARCTest_arc_OBJECTS = \
"CMakeFiles/ARCTest_arc.dir/ARCTest_arc.m.o"

# External object files for target ARCTest_arc
ARCTest_arc_EXTERNAL_OBJECTS = \
"/Users/xiaoniu/Desktop/libobjc2/Test/CMakeFiles/test_runtime.dir/Test.m.o"

Test/ARCTest_arc: Test/CMakeFiles/ARCTest_arc.dir/ARCTest_arc.m.o
Test/ARCTest_arc: Test/CMakeFiles/test_runtime.dir/Test.m.o
Test/ARCTest_arc: Test/CMakeFiles/ARCTest_arc.dir/build.make
Test/ARCTest_arc: libobjc.4.6.dylib
Test/ARCTest_arc: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.3.sdk/usr/lib/libc++abi.tbd
Test/ARCTest_arc: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.3.sdk/usr/lib/libm.tbd
Test/ARCTest_arc: Test/CMakeFiles/ARCTest_arc.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/xiaoniu/Desktop/libobjc2/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable ARCTest_arc"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/ARCTest_arc.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
Test/CMakeFiles/ARCTest_arc.dir/build: Test/ARCTest_arc
.PHONY : Test/CMakeFiles/ARCTest_arc.dir/build

Test/CMakeFiles/ARCTest_arc.dir/clean:
	cd /Users/xiaoniu/Desktop/libobjc2/Test && $(CMAKE_COMMAND) -P CMakeFiles/ARCTest_arc.dir/cmake_clean.cmake
.PHONY : Test/CMakeFiles/ARCTest_arc.dir/clean

Test/CMakeFiles/ARCTest_arc.dir/depend:
	cd /Users/xiaoniu/Desktop/libobjc2 && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/xiaoniu/Desktop/libobjc2 /Users/xiaoniu/Desktop/libobjc2/Test /Users/xiaoniu/Desktop/libobjc2 /Users/xiaoniu/Desktop/libobjc2/Test /Users/xiaoniu/Desktop/libobjc2/Test/CMakeFiles/ARCTest_arc.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : Test/CMakeFiles/ARCTest_arc.dir/depend

