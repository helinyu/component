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
include Test/CMakeFiles/hash_test_optimised.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include Test/CMakeFiles/hash_test_optimised.dir/compiler_depend.make

# Include the progress variables for this target.
include Test/CMakeFiles/hash_test_optimised.dir/progress.make

# Include the compile flags for this target's objects.
include Test/CMakeFiles/hash_test_optimised.dir/flags.make

Test/CMakeFiles/hash_test_optimised.dir/hash_test.c.o: Test/CMakeFiles/hash_test_optimised.dir/flags.make
Test/CMakeFiles/hash_test_optimised.dir/hash_test.c.o: Test/hash_test.c
Test/CMakeFiles/hash_test_optimised.dir/hash_test.c.o: Test/CMakeFiles/hash_test_optimised.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/xiaoniu/Desktop/libobjc2/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object Test/CMakeFiles/hash_test_optimised.dir/hash_test.c.o"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT Test/CMakeFiles/hash_test_optimised.dir/hash_test.c.o -MF CMakeFiles/hash_test_optimised.dir/hash_test.c.o.d -o CMakeFiles/hash_test_optimised.dir/hash_test.c.o -c /Users/xiaoniu/Desktop/libobjc2/Test/hash_test.c

Test/CMakeFiles/hash_test_optimised.dir/hash_test.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/hash_test_optimised.dir/hash_test.c.i"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/xiaoniu/Desktop/libobjc2/Test/hash_test.c > CMakeFiles/hash_test_optimised.dir/hash_test.c.i

Test/CMakeFiles/hash_test_optimised.dir/hash_test.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/hash_test_optimised.dir/hash_test.c.s"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/xiaoniu/Desktop/libobjc2/Test/hash_test.c -o CMakeFiles/hash_test_optimised.dir/hash_test.c.s

# Object files for target hash_test_optimised
hash_test_optimised_OBJECTS = \
"CMakeFiles/hash_test_optimised.dir/hash_test.c.o"

# External object files for target hash_test_optimised
hash_test_optimised_EXTERNAL_OBJECTS = \
"/Users/xiaoniu/Desktop/libobjc2/Test/CMakeFiles/test_runtime.dir/Test.m.o"

Test/hash_test_optimised: Test/CMakeFiles/hash_test_optimised.dir/hash_test.c.o
Test/hash_test_optimised: Test/CMakeFiles/test_runtime.dir/Test.m.o
Test/hash_test_optimised: Test/CMakeFiles/hash_test_optimised.dir/build.make
Test/hash_test_optimised: libobjc.4.6.dylib
Test/hash_test_optimised: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.3.sdk/usr/lib/libc++abi.tbd
Test/hash_test_optimised: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.3.sdk/usr/lib/libm.tbd
Test/hash_test_optimised: Test/CMakeFiles/hash_test_optimised.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/xiaoniu/Desktop/libobjc2/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable hash_test_optimised"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/hash_test_optimised.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
Test/CMakeFiles/hash_test_optimised.dir/build: Test/hash_test_optimised
.PHONY : Test/CMakeFiles/hash_test_optimised.dir/build

Test/CMakeFiles/hash_test_optimised.dir/clean:
	cd /Users/xiaoniu/Desktop/libobjc2/Test && $(CMAKE_COMMAND) -P CMakeFiles/hash_test_optimised.dir/cmake_clean.cmake
.PHONY : Test/CMakeFiles/hash_test_optimised.dir/clean

Test/CMakeFiles/hash_test_optimised.dir/depend:
	cd /Users/xiaoniu/Desktop/libobjc2 && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/xiaoniu/Desktop/libobjc2 /Users/xiaoniu/Desktop/libobjc2/Test /Users/xiaoniu/Desktop/libobjc2 /Users/xiaoniu/Desktop/libobjc2/Test /Users/xiaoniu/Desktop/libobjc2/Test/CMakeFiles/hash_test_optimised.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : Test/CMakeFiles/hash_test_optimised.dir/depend
