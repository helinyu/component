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
include Test/CMakeFiles/objc_msgSend.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include Test/CMakeFiles/objc_msgSend.dir/compiler_depend.make

# Include the progress variables for this target.
include Test/CMakeFiles/objc_msgSend.dir/progress.make

# Include the compile flags for this target's objects.
include Test/CMakeFiles/objc_msgSend.dir/flags.make

Test/CMakeFiles/objc_msgSend.dir/objc_msgSend.m.o: Test/CMakeFiles/objc_msgSend.dir/flags.make
Test/CMakeFiles/objc_msgSend.dir/objc_msgSend.m.o: Test/objc_msgSend.m
Test/CMakeFiles/objc_msgSend.dir/objc_msgSend.m.o: Test/CMakeFiles/objc_msgSend.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/xiaoniu/Desktop/libobjc2/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object Test/CMakeFiles/objc_msgSend.dir/objc_msgSend.m.o"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT Test/CMakeFiles/objc_msgSend.dir/objc_msgSend.m.o -MF CMakeFiles/objc_msgSend.dir/objc_msgSend.m.o.d -o CMakeFiles/objc_msgSend.dir/objc_msgSend.m.o -c /Users/xiaoniu/Desktop/libobjc2/Test/objc_msgSend.m

Test/CMakeFiles/objc_msgSend.dir/objc_msgSend.m.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/objc_msgSend.dir/objc_msgSend.m.i"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/xiaoniu/Desktop/libobjc2/Test/objc_msgSend.m > CMakeFiles/objc_msgSend.dir/objc_msgSend.m.i

Test/CMakeFiles/objc_msgSend.dir/objc_msgSend.m.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/objc_msgSend.dir/objc_msgSend.m.s"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/xiaoniu/Desktop/libobjc2/Test/objc_msgSend.m -o CMakeFiles/objc_msgSend.dir/objc_msgSend.m.s

# Object files for target objc_msgSend
objc_msgSend_OBJECTS = \
"CMakeFiles/objc_msgSend.dir/objc_msgSend.m.o"

# External object files for target objc_msgSend
objc_msgSend_EXTERNAL_OBJECTS = \
"/Users/xiaoniu/Desktop/libobjc2/Test/CMakeFiles/test_runtime.dir/Test.m.o"

Test/objc_msgSend: Test/CMakeFiles/objc_msgSend.dir/objc_msgSend.m.o
Test/objc_msgSend: Test/CMakeFiles/test_runtime.dir/Test.m.o
Test/objc_msgSend: Test/CMakeFiles/objc_msgSend.dir/build.make
Test/objc_msgSend: libobjc.4.6.dylib
Test/objc_msgSend: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.3.sdk/usr/lib/libc++abi.tbd
Test/objc_msgSend: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.3.sdk/usr/lib/libm.tbd
Test/objc_msgSend: Test/CMakeFiles/objc_msgSend.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/xiaoniu/Desktop/libobjc2/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable objc_msgSend"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/objc_msgSend.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
Test/CMakeFiles/objc_msgSend.dir/build: Test/objc_msgSend
.PHONY : Test/CMakeFiles/objc_msgSend.dir/build

Test/CMakeFiles/objc_msgSend.dir/clean:
	cd /Users/xiaoniu/Desktop/libobjc2/Test && $(CMAKE_COMMAND) -P CMakeFiles/objc_msgSend.dir/cmake_clean.cmake
.PHONY : Test/CMakeFiles/objc_msgSend.dir/clean

Test/CMakeFiles/objc_msgSend.dir/depend:
	cd /Users/xiaoniu/Desktop/libobjc2 && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/xiaoniu/Desktop/libobjc2 /Users/xiaoniu/Desktop/libobjc2/Test /Users/xiaoniu/Desktop/libobjc2 /Users/xiaoniu/Desktop/libobjc2/Test /Users/xiaoniu/Desktop/libobjc2/Test/CMakeFiles/objc_msgSend.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : Test/CMakeFiles/objc_msgSend.dir/depend

