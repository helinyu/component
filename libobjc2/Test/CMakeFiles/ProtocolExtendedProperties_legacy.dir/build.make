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
include Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/compiler_depend.make

# Include the progress variables for this target.
include Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/progress.make

# Include the compile flags for this target's objects.
include Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/flags.make

Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/ProtocolExtendedProperties.m.o: Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/flags.make
Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/ProtocolExtendedProperties.m.o: Test/ProtocolExtendedProperties.m
Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/ProtocolExtendedProperties.m.o: Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/xiaoniu/Desktop/libobjc2/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/ProtocolExtendedProperties.m.o"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/ProtocolExtendedProperties.m.o -MF CMakeFiles/ProtocolExtendedProperties_legacy.dir/ProtocolExtendedProperties.m.o.d -o CMakeFiles/ProtocolExtendedProperties_legacy.dir/ProtocolExtendedProperties.m.o -c /Users/xiaoniu/Desktop/libobjc2/Test/ProtocolExtendedProperties.m

Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/ProtocolExtendedProperties.m.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/ProtocolExtendedProperties_legacy.dir/ProtocolExtendedProperties.m.i"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/xiaoniu/Desktop/libobjc2/Test/ProtocolExtendedProperties.m > CMakeFiles/ProtocolExtendedProperties_legacy.dir/ProtocolExtendedProperties.m.i

Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/ProtocolExtendedProperties.m.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/ProtocolExtendedProperties_legacy.dir/ProtocolExtendedProperties.m.s"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/xiaoniu/Desktop/libobjc2/Test/ProtocolExtendedProperties.m -o CMakeFiles/ProtocolExtendedProperties_legacy.dir/ProtocolExtendedProperties.m.s

# Object files for target ProtocolExtendedProperties_legacy
ProtocolExtendedProperties_legacy_OBJECTS = \
"CMakeFiles/ProtocolExtendedProperties_legacy.dir/ProtocolExtendedProperties.m.o"

# External object files for target ProtocolExtendedProperties_legacy
ProtocolExtendedProperties_legacy_EXTERNAL_OBJECTS = \
"/Users/xiaoniu/Desktop/libobjc2/Test/CMakeFiles/test_runtime_legacy.dir/Test.m.o"

Test/ProtocolExtendedProperties_legacy: Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/ProtocolExtendedProperties.m.o
Test/ProtocolExtendedProperties_legacy: Test/CMakeFiles/test_runtime_legacy.dir/Test.m.o
Test/ProtocolExtendedProperties_legacy: Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/build.make
Test/ProtocolExtendedProperties_legacy: libobjc.4.6.dylib
Test/ProtocolExtendedProperties_legacy: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.3.sdk/usr/lib/libc++abi.tbd
Test/ProtocolExtendedProperties_legacy: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.3.sdk/usr/lib/libm.tbd
Test/ProtocolExtendedProperties_legacy: Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/xiaoniu/Desktop/libobjc2/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable ProtocolExtendedProperties_legacy"
	cd /Users/xiaoniu/Desktop/libobjc2/Test && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/ProtocolExtendedProperties_legacy.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/build: Test/ProtocolExtendedProperties_legacy
.PHONY : Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/build

Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/clean:
	cd /Users/xiaoniu/Desktop/libobjc2/Test && $(CMAKE_COMMAND) -P CMakeFiles/ProtocolExtendedProperties_legacy.dir/cmake_clean.cmake
.PHONY : Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/clean

Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/depend:
	cd /Users/xiaoniu/Desktop/libobjc2 && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/xiaoniu/Desktop/libobjc2 /Users/xiaoniu/Desktop/libobjc2/Test /Users/xiaoniu/Desktop/libobjc2 /Users/xiaoniu/Desktop/libobjc2/Test /Users/xiaoniu/Desktop/libobjc2/Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : Test/CMakeFiles/ProtocolExtendedProperties_legacy.dir/depend

