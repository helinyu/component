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
include Test/CMakeFiles/msgInterpose.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include Test/CMakeFiles/msgInterpose.dir/compiler_depend.make

# Include the progress variables for this target.
include Test/CMakeFiles/msgInterpose.dir/progress.make

# Include the compile flags for this target's objects.
include Test/CMakeFiles/msgInterpose.dir/flags.make

Test/CMakeFiles/msgInterpose.dir/msgInterpose.m.o: Test/CMakeFiles/msgInterpose.dir/flags.make
Test/CMakeFiles/msgInterpose.dir/msgInterpose.m.o: Test/msgInterpose.m
Test/CMakeFiles/msgInterpose.dir/msgInterpose.m.o: Test/CMakeFiles/msgInterpose.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/xiaoniu/Desktop/libobjc2/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object Test/CMakeFiles/msgInterpose.dir/msgInterpose.m.o"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT Test/CMakeFiles/msgInterpose.dir/msgInterpose.m.o -MF CMakeFiles/msgInterpose.dir/msgInterpose.m.o.d -o CMakeFiles/msgInterpose.dir/msgInterpose.m.o -c /Users/xiaoniu/Desktop/libobjc2/Test/msgInterpose.m

Test/CMakeFiles/msgInterpose.dir/msgInterpose.m.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/msgInterpose.dir/msgInterpose.m.i"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/xiaoniu/Desktop/libobjc2/Test/msgInterpose.m > CMakeFiles/msgInterpose.dir/msgInterpose.m.i

Test/CMakeFiles/msgInterpose.dir/msgInterpose.m.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/msgInterpose.dir/msgInterpose.m.s"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/xiaoniu/Desktop/libobjc2/Test/msgInterpose.m -o CMakeFiles/msgInterpose.dir/msgInterpose.m.s

# Object files for target msgInterpose
msgInterpose_OBJECTS = \
"CMakeFiles/msgInterpose.dir/msgInterpose.m.o"

# External object files for target msgInterpose
msgInterpose_EXTERNAL_OBJECTS = \
"/Users/xiaoniu/Desktop/libobjc2/Test/CMakeFiles/test_runtime.dir/Test.m.o"

Test/msgInterpose: Test/CMakeFiles/msgInterpose.dir/msgInterpose.m.o
Test/msgInterpose: Test/CMakeFiles/test_runtime.dir/Test.m.o
Test/msgInterpose: Test/CMakeFiles/msgInterpose.dir/build.make
Test/msgInterpose: libobjc.4.6.dylib
Test/msgInterpose: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.3.sdk/usr/lib/libc++abi.tbd
Test/msgInterpose: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.3.sdk/usr/lib/libm.tbd
Test/msgInterpose: Test/CMakeFiles/msgInterpose.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/xiaoniu/Desktop/libobjc2/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable msgInterpose"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/msgInterpose.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
Test/CMakeFiles/msgInterpose.dir/build: Test/msgInterpose
.PHONY : Test/CMakeFiles/msgInterpose.dir/build

Test/CMakeFiles/msgInterpose.dir/clean:
	cd /Users/xiaoniu/Desktop/libobjc2/Test && $(CMAKE_COMMAND) -P CMakeFiles/msgInterpose.dir/cmake_clean.cmake
.PHONY : Test/CMakeFiles/msgInterpose.dir/clean

Test/CMakeFiles/msgInterpose.dir/depend:
	cd /Users/xiaoniu/Desktop/libobjc2 && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/xiaoniu/Desktop/libobjc2 /Users/xiaoniu/Desktop/libobjc2/Test /Users/xiaoniu/Desktop/libobjc2 /Users/xiaoniu/Desktop/libobjc2/Test /Users/xiaoniu/Desktop/libobjc2/Test/CMakeFiles/msgInterpose.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : Test/CMakeFiles/msgInterpose.dir/depend
