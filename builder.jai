#import "Basic";
#import "Compiler";
#import "String";

build_static_library :: () {
    // create a new workspace to generate a static library
    static_builder_workspace := compiler_create_workspace("Static Library Builder");

    options := get_build_options();
    options.output_executable_name = "libjai"; // suffix '.a' added automatically
    options.output_path            = "./build_output/";
    options.output_type            = .STATIC_LIBRARY;

    set_optimization(*options, Optimization_Type.DEBUG);
    set_build_options(options, static_builder_workspace);

    add_build_file("lib.jai", static_builder_workspace);
}

build_executable :: () {
    executable_builder_workspace := compiler_create_workspace("Executable Builder");

    options := get_build_options();
    options.output_executable_name = "main_jai";
    options.output_path            = "./build_output/";
    options.output_type            = .EXECUTABLE;

    set_optimization(*options, Optimization_Type.DEBUG);
    set_build_options(options, executable_builder_workspace);

    add_build_file("main.jai", executable_builder_workspace);
}

build :: () {
    // prevent the default workspace from producing any output, since we do so instead
    // in separate workspaces.
    set_build_options_dc(.{do_output=false});

    build_lib := false;
    build_exe := false;

    build_options := get_build_options();
    args := build_options.compile_time_command_line;
    for args {
        if      !compare(it, "-build-lib")  build_lib = true;
        else if !compare(it, "-build-exe")  build_exe = true;
    }

    // default build everything
    if !build_lib && !build_exe {
        build_lib = true;
        build_exe = true;
    }

    if build_lib  build_static_library();
    if build_exe  build_executable();
}

#run build();
