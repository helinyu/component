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
include Test/CMakeFiles/ObjCXXEHInterop.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include Test/CMakeFiles/ObjCXXEHInterop.dir/compiler_depend.make

# Include the progress variables for this target.
include Test/CMakeFiles/ObjCXXEHInterop.dir/progress.make

# Include the compile flags for this target's objects.
include Test/CMakeFiles/ObjCXXEHInterop.dir/flags.make

Test/CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.mm.o: Test/CMakeFiles/ObjCXXEHInterop.dir/flags.make
Test/CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.mm.o: Test/ObjCXXEHInterop.mm
Test/CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.mm.o: Test/CMakeFiles/ObjCXXEHInterop.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/xiaoniu/Desktop/libobjc2/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object Test/CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.mm.o"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT Test/CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.mm.o -MF CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.mm.o.d -o CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.mm.o -c /Users/xiaoniu/Desktop/libobjc2/Test/ObjCXXEHInterop.mm

Test/CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.mm.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.mm.i"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/xiaoniu/Desktop/libobjc2/Test/ObjCXXEHInterop.mm > CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.mm.i

Test/CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.mm.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.mm.s"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/xiaoniu/Desktop/libobjc2/Test/ObjCXXEHInterop.mm -o CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.mm.s

Test/CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.m.o: Test/CMakeFiles/ObjCXXEHInterop.dir/flags.make
Test/CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.m.o: Test/ObjCXXEHInterop.m
Test/CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.m.o: Test/CMakeFiles/ObjCXXEHInterop.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/xiaoniu/Desktop/libobjc2/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object Test/CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.m.o"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT Test/CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.m.o -MF CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.m.o.d -o CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.m.o -c /Users/xiaoniu/Desktop/libobjc2/Test/ObjCXXEHInterop.m

Test/CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.m.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.m.i"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/xiaoniu/Desktop/libobjc2/Test/ObjCXXEHInterop.m > CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.m.i

Test/CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.m.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.m.s"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/xiaoniu/Desktop/libobjc2/Test/ObjCXXEHInterop.m -o CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.m.s

# Object files for target ObjCXXEHInterop
ObjCXXEHInterop_OBJECTS = \
"CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.mm.o" \
"CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.m.o"

# External object files for target ObjCXXEHInterop
ObjCXXEHInterop_EXTERNAL_OBJECTS = \
"/Users/xiaoniu/Desktop/libobjc2/Test/CMakeFiles/test_runtime.dir/Test.m.o"

Test/ObjCXXEHInterop: Test/CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.mm.o
Test/ObjCXXEHInterop: Test/CMakeFiles/ObjCXXEHInterop.dir/ObjCXXEHInterop.m.o
Test/ObjCXXEHInterop: Test/CMakeFiles/test_runtime.dir/Test.m.o
Test/ObjCXXEHInterop: Test/CMakeFiles/ObjCXXEHInterop.dir/build.make
Test/ObjCXXEHInterop: libobjc.4.6.dylib
Test/ObjCXXEHInterop: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.3.sdk/usr/lib/libc++abi.tbd
Test/ObjCXXEHInterop: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.3.sdk/usr/lib/libm.tbd
Test/ObjCXXEHInterop: Test/CMakeFiles/ObjCXXEHInterop.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/xiaoniu/Desktop/libobjc2/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking C executable ObjCXXEHInterop"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/ObjCXXEHInterop.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
Test/CMakeFiles/ObjCXXEHInterop.dir/build: Test/ObjCXXEHInterop
.PHONY : Test/CMakeFiles/ObjCXXEHInterop.dir/build

Test/CMakeFiles/ObjCXXEHInterop.dir/clean:
	cd /Users/xiaoniu/Desktop/libobjc2/Test && $(CMAKE_COMMAND) -P CMakeFiles/ObjCXXEHInterop.dir/cmake_clean.cmake
.PHONY : Test/CMakeFiles/ObjCXXEHInterop.dir/clean

Test/CMakeFiles/ObjCXXEHInterop.dir/depend:
	cd /Users/xiaoniu/Desktop/libobjc2 && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/xiaoniu/Desktop/libobjc2 /Users/xiaoniu/Desktop/libobjc2/Test /Users/xiaoniu/Desktop/libobjc2 /Users/xiaoniu/Desktop/libobjc2/Test /Users/xiaoniu/Desktop/libobjc2/Test/CMakeFiles/ObjCXXEHInterop.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : Test/CMakeFiles/ObjCXXEHInterop.dir/depend
