from vunit import VUnit

vu = VUnit.from_argv()
vu.add_osvvm()
lib = vu.add_library('lib')
lib.add_source_files('test/*.vhd')
lib.add_source_files('src/common_pkg.vhd')
lib.add_source_files('src/register_pair.vhd')
lib.add_source_files('src/register_file.vhd')
lib.add_source_files('src/status_register.vhd')

vu.main()
