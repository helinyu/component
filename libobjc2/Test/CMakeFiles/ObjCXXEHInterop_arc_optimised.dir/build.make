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
include Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/compiler_depend.make

# Include the progress variables for this target.
include Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/progress.make

# Include the compile flags for this target's objects.
include Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/flags.make

Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.mm.o: Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/flags.make
Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.mm.o: Test/ObjCXXEHInterop_arc.mm
Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.mm.o: Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/xiaoniu/Desktop/libobjc2/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.mm.o"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -Xclang -fobjc-arc -MD -MT Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.mm.o -MF CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.mm.o.d -o CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.mm.o -c /Users/xiaoniu/Desktop/libobjc2/Test/ObjCXXEHInterop_arc.mm

Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.mm.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.mm.i"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -Xclang -fobjc-arc -E /Users/xiaoniu/Desktop/libobjc2/Test/ObjCXXEHInterop_arc.mm > CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.mm.i

Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.mm.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.mm.s"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -Xclang -fobjc-arc -S /Users/xiaoniu/Desktop/libobjc2/Test/ObjCXXEHInterop_arc.mm -o CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.mm.s

Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.m.o: Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/flags.make
Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.m.o: Test/ObjCXXEHInterop_arc.m
Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.m.o: Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/xiaoniu/Desktop/libobjc2/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.m.o"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -Xclang -fobjc-arc -MD -MT Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.m.o -MF CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.m.o.d -o CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.m.o -c /Users/xiaoniu/Desktop/libobjc2/Test/ObjCXXEHInterop_arc.m

Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.m.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.m.i"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -Xclang -fobjc-arc -E /Users/xiaoniu/Desktop/libobjc2/Test/ObjCXXEHInterop_arc.m > CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.m.i

Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.m.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.m.s"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -Xclang -fobjc-arc -S /Users/xiaoniu/Desktop/libobjc2/Test/ObjCXXEHInterop_arc.m -o CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.m.s

# Object files for target ObjCXXEHInterop_arc_optimised
ObjCXXEHInterop_arc_optimised_OBJECTS = \
"CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.mm.o" \
"CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.m.o"

# External object files for target ObjCXXEHInterop_arc_optimised
ObjCXXEHInterop_arc_optimised_EXTERNAL_OBJECTS = \
"/Users/xiaoniu/Desktop/libobjc2/Test/CMakeFiles/test_runtime.dir/Test.m.o"

Test/ObjCXXEHInterop_arc_optimised: Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.mm.o
Test/ObjCXXEHInterop_arc_optimised: Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/ObjCXXEHInterop_arc.m.o
Test/ObjCXXEHInterop_arc_optimised: Test/CMakeFiles/test_runtime.dir/Test.m.o
Test/ObjCXXEHInterop_arc_optimised: Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/build.make
Test/ObjCXXEHInterop_arc_optimised: libobjc.4.6.dylib
Test/ObjCXXEHInterop_arc_optimised: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.3.sdk/usr/lib/libc++abi.tbd
Test/ObjCXXEHInterop_arc_optimised: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.3.sdk/usr/lib/libm.tbd
Test/ObjCXXEHInterop_arc_optimised: Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/xiaoniu/Desktop/libobjc2/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking C executable ObjCXXEHInterop_arc_optimised"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/build: Test/ObjCXXEHInterop_arc_optimised
.PHONY : Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/build

Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/clean:
	cd /Users/xiaoniu/Desktop/libobjc2/Test && $(CMAKE_COMMAND) -P CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/cmake_clean.cmake
.PHONY : Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/clean

Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/depend:
	cd /Users/xiaoniu/Desktop/libobjc2 && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/xiaoniu/Desktop/libobjc2 /Users/xiaoniu/Desktop/libobjc2/Test /Users/xiaoniu/Desktop/libobjc2 /Users/xiaoniu/Desktop/libobjc2/Test /Users/xiaoniu/Desktop/libobjc2/Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : Test/CMakeFiles/ObjCXXEHInterop_arc_optimised.dir/depend

