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
include Test/CMakeFiles/CXXExceptions_optimised.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include Test/CMakeFiles/CXXExceptions_optimised.dir/compiler_depend.make

# Include the progress variables for this target.
include Test/CMakeFiles/CXXExceptions_optimised.dir/progress.make

# Include the compile flags for this target's objects.
include Test/CMakeFiles/CXXExceptions_optimised.dir/flags.make

Test/CMakeFiles/CXXExceptions_optimised.dir/CXXException.m.o: Test/CMakeFiles/CXXExceptions_optimised.dir/flags.make
Test/CMakeFiles/CXXExceptions_optimised.dir/CXXException.m.o: Test/CXXException.m
Test/CMakeFiles/CXXExceptions_optimised.dir/CXXException.m.o: Test/CMakeFiles/CXXExceptions_optimised.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/xiaoniu/Desktop/libobjc2/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object Test/CMakeFiles/CXXExceptions_optimised.dir/CXXException.m.o"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT Test/CMakeFiles/CXXExceptions_optimised.dir/CXXException.m.o -MF CMakeFiles/CXXExceptions_optimised.dir/CXXException.m.o.d -o CMakeFiles/CXXExceptions_optimised.dir/CXXException.m.o -c /Users/xiaoniu/Desktop/libobjc2/Test/CXXException.m

Test/CMakeFiles/CXXExceptions_optimised.dir/CXXException.m.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/CXXExceptions_optimised.dir/CXXException.m.i"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/xiaoniu/Desktop/libobjc2/Test/CXXException.m > CMakeFiles/CXXExceptions_optimised.dir/CXXException.m.i

Test/CMakeFiles/CXXExceptions_optimised.dir/CXXException.m.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/CXXExceptions_optimised.dir/CXXException.m.s"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/xiaoniu/Desktop/libobjc2/Test/CXXException.m -o CMakeFiles/CXXExceptions_optimised.dir/CXXException.m.s

Test/CMakeFiles/CXXExceptions_optimised.dir/CXXException.cc.o: Test/CMakeFiles/CXXExceptions_optimised.dir/flags.make
Test/CMakeFiles/CXXExceptions_optimised.dir/CXXException.cc.o: Test/CXXException.cc
Test/CMakeFiles/CXXExceptions_optimised.dir/CXXException.cc.o: Test/CMakeFiles/CXXExceptions_optimised.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/xiaoniu/Desktop/libobjc2/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object Test/CMakeFiles/CXXExceptions_optimised.dir/CXXException.cc.o"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT Test/CMakeFiles/CXXExceptions_optimised.dir/CXXException.cc.o -MF CMakeFiles/CXXExceptions_optimised.dir/CXXException.cc.o.d -o CMakeFiles/CXXExceptions_optimised.dir/CXXException.cc.o -c /Users/xiaoniu/Desktop/libobjc2/Test/CXXException.cc

Test/CMakeFiles/CXXExceptions_optimised.dir/CXXException.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/CXXExceptions_optimised.dir/CXXException.cc.i"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/xiaoniu/Desktop/libobjc2/Test/CXXException.cc > CMakeFiles/CXXExceptions_optimised.dir/CXXException.cc.i

Test/CMakeFiles/CXXExceptions_optimised.dir/CXXException.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/CXXExceptions_optimised.dir/CXXException.cc.s"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/xiaoniu/Desktop/libobjc2/Test/CXXException.cc -o CMakeFiles/CXXExceptions_optimised.dir/CXXException.cc.s

# Object files for target CXXExceptions_optimised
CXXExceptions_optimised_OBJECTS = \
"CMakeFiles/CXXExceptions_optimised.dir/CXXException.m.o" \
"CMakeFiles/CXXExceptions_optimised.dir/CXXException.cc.o"

# External object files for target CXXExceptions_optimised
CXXExceptions_optimised_EXTERNAL_OBJECTS = \
"/Users/xiaoniu/Desktop/libobjc2/Test/CMakeFiles/test_runtime.dir/Test.m.o"

Test/CXXExceptions_optimised: Test/CMakeFiles/CXXExceptions_optimised.dir/CXXException.m.o
Test/CXXExceptions_optimised: Test/CMakeFiles/CXXExceptions_optimised.dir/CXXException.cc.o
Test/CXXExceptions_optimised: Test/CMakeFiles/test_runtime.dir/Test.m.o
Test/CXXExceptions_optimised: Test/CMakeFiles/CXXExceptions_optimised.dir/build.make
Test/CXXExceptions_optimised: libobjc.4.6.dylib
Test/CXXExceptions_optimised: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.3.sdk/usr/lib/libc++abi.tbd
Test/CXXExceptions_optimised: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.3.sdk/usr/lib/libm.tbd
Test/CXXExceptions_optimised: Test/CMakeFiles/CXXExceptions_optimised.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/xiaoniu/Desktop/libobjc2/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking C executable CXXExceptions_optimised"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/CXXExceptions_optimised.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
Test/CMakeFiles/CXXExceptions_optimised.dir/build: Test/CXXExceptions_optimised
.PHONY : Test/CMakeFiles/CXXExceptions_optimised.dir/build

Test/CMakeFiles/CXXExceptions_optimised.dir/clean:
	cd /Users/xiaoniu/Desktop/libobjc2/Test && $(CMAKE_COMMAND) -P CMakeFiles/CXXExceptions_optimised.dir/cmake_clean.cmake
.PHONY : Test/CMakeFiles/CXXExceptions_optimised.dir/clean

Test/CMakeFiles/CXXExceptions_optimised.dir/depend:
	cd /Users/xiaoniu/Desktop/libobjc2 && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/xiaoniu/Desktop/libobjc2 /Users/xiaoniu/Desktop/libobjc2/Test /Users/xiaoniu/Desktop/libobjc2 /Users/xiaoniu/Desktop/libobjc2/Test /Users/xiaoniu/Desktop/libobjc2/Test/CMakeFiles/CXXExceptions_optimised.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : Test/CMakeFiles/CXXExceptions_optimised.dir/depend

