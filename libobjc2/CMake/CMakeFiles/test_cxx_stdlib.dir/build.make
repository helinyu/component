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
CMAKE_SOURCE_DIR = /Users/xiaoniu/Desktop/libobjc2/CMake

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/xiaoniu/Desktop/libobjc2/CMake

# Include any dependencies generated for this target.
include CMakeFiles/test_cxx_stdlib.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/test_cxx_stdlib.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/test_cxx_stdlib.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/test_cxx_stdlib.dir/flags.make

CMakeFiles/test_cxx_stdlib.dir/typeinfo_test.cc.o: CMakeFiles/test_cxx_stdlib.dir/flags.make
CMakeFiles/test_cxx_stdlib.dir/typeinfo_test.cc.o: typeinfo_test.cc
CMakeFiles/test_cxx_stdlib.dir/typeinfo_test.cc.o: CMakeFiles/test_cxx_stdlib.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --progress-dir=/Users/xiaoniu/Desktop/libobjc2/CMake/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/test_cxx_stdlib.dir/typeinfo_test.cc.o"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/test_cxx_stdlib.dir/typeinfo_test.cc.o -MF CMakeFiles/test_cxx_stdlib.dir/typeinfo_test.cc.o.d -o CMakeFiles/test_cxx_stdlib.dir/typeinfo_test.cc.o -c /Users/xiaoniu/Desktop/libobjc2/CMake/typeinfo_test.cc

CMakeFiles/test_cxx_stdlib.dir/typeinfo_test.cc.i: cmake_force
	@echo "Preprocessing CXX source to CMakeFiles/test_cxx_stdlib.dir/typeinfo_test.cc.i"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/xiaoniu/Desktop/libobjc2/CMake/typeinfo_test.cc > CMakeFiles/test_cxx_stdlib.dir/typeinfo_test.cc.i

CMakeFiles/test_cxx_stdlib.dir/typeinfo_test.cc.s: cmake_force
	@echo "Compiling CXX source to assembly CMakeFiles/test_cxx_stdlib.dir/typeinfo_test.cc.s"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/xiaoniu/Desktop/libobjc2/CMake/typeinfo_test.cc -o CMakeFiles/test_cxx_stdlib.dir/typeinfo_test.cc.s

# Object files for target test_cxx_stdlib
test_cxx_stdlib_OBJECTS = \
"CMakeFiles/test_cxx_stdlib.dir/typeinfo_test.cc.o"

# External object files for target test_cxx_stdlib
test_cxx_stdlib_EXTERNAL_OBJECTS =

test_cxx_stdlib: CMakeFiles/test_cxx_stdlib.dir/typeinfo_test.cc.o
test_cxx_stdlib: CMakeFiles/test_cxx_stdlib.dir/build.make
test_cxx_stdlib: CMakeFiles/test_cxx_stdlib.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --progress-dir=/Users/xiaoniu/Desktop/libobjc2/CMake/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable test_cxx_stdlib"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/test_cxx_stdlib.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/test_cxx_stdlib.dir/build: test_cxx_stdlib
.PHONY : CMakeFiles/test_cxx_stdlib.dir/build

CMakeFiles/test_cxx_stdlib.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/test_cxx_stdlib.dir/cmake_clean.cmake
.PHONY : CMakeFiles/test_cxx_stdlib.dir/clean

CMakeFiles/test_cxx_stdlib.dir/depend:
	cd /Users/xiaoniu/Desktop/libobjc2/CMake && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/xiaoniu/Desktop/libobjc2/CMake /Users/xiaoniu/Desktop/libobjc2/CMake /Users/xiaoniu/Desktop/libobjc2/CMake /Users/xiaoniu/Desktop/libobjc2/CMake /Users/xiaoniu/Desktop/libobjc2/CMake/CMakeFiles/test_cxx_stdlib.dir/DependInfo.cmake
.PHONY : CMakeFiles/test_cxx_stdlib.dir/depend

