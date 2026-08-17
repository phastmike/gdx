project('gdx', ['vala', 'c'],
	version: '0.1.1',
	license: 'MIT',	
   meson_version: '>=0.37')

i18n = import('i18n')

sqlite3 = dependency('sqlite3')
gtk = dependency('gtk4', version: '>=4.00')
gio = dependency('gio-2.0', version: '>=2.32')
gee = dependency('gee-0.8', version: '>=0.18')
glib = dependency('glib-2.0', version: '>=2.76')
gobject = dependency('gobject-2.0', version: '>=2.76')
adwaita = dependency('libadwaita-1', version: '>= 1.2')
posix = meson.get_compiler('vala').find_library('posix')

conf = configuration_data()
conf.set_quoted('VERSION', meson.project_version())
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
conf.set_quoted('GNOMELOCALEDIR', get_option('prefix') + '/' + get_option('localedir'))
configure_file(output: 'config.h', configuration: conf)
config_h_dir = include_directories('.')

c_args = [
  '-include', 'config.h',
]

subdir('data')
subdir('po')
subdir('src')
subdir('tests')

meson.add_install_script('meson-post-install.py')
