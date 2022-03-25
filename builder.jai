#import "Basic";
#import "Compiler";

build_static_library :: () {
   // create a new workspace to generate a static library
   static_builder_workspace := compiler_create_workspace("Static Library Builder");

   options := get_build_options();
   options.output_executable_name = "libjai.a";
   options.output_path            = "./build_output/";
   options.output_type            = .STATIC_LIBRARY;
   options.optimization_level     = .DEBUG;

   set_build_options(options, static_builder_workspace);

   add_build_file("lib.jai", static_builder_workspace);
}

build_executable :: () {
   executable_builder_workspace := compiler_create_workspace("Executable Builder");

   options := get_build_options();
   options.output_executable_name = "main_jai";
   options.output_path            = "./build_output/";
   options.output_type            = .EXECUTABLE;
   options.optimization_level     = .DEBUG;
   // options.additional_linker_arguments = .["-L build_output -llibasm"];

   set_build_options(options, executable_builder_workspace);

   add_build_file("main.jai", executable_builder_workspace);
}

build :: () {
   // prevent the default workspace from producing any output
   set_build_options_dc(.{do_output=false});

   build_static_library();
   build_executable();
}

#run build();
