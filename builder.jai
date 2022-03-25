#import "Basic";
#import "Compiler";

build :: () {
   // prevent the default workspace from producing any output
   set_build_options_dc(.{do_output=false});

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

#run build();
