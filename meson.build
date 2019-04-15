project('gdx', ['vala', 'c'],
	version: '0.1.1',
	license: 'MIT',	
        meson_version: '>=0.37')

i18n = import('i18n')

gio = dependency('gio-2.0', version: '>=2.32')
gtk = dependency('gtk+-3.0', version: '>=3.18')
gee = dependency('gee-0.8', version: '>=0.18')
glib = dependency('glib-2.0', version: '>=2.32')
gobject = dependency('gobject-2.0', version: '>=2.32')
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
