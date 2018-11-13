project('gdx', ['vala', 'c'],
	version: '1.0.0',
	license: 'MIT',	
   meson_version: '>=0.37')

i18n = import('i18n')

gio = dependency('gio-2.0', version: '>=2.32')
gtk = dependency('gtk+-3.0', version: '>=3.18')
gee = dependency('gee-0.8', version: '>=0.8')
glib = dependency('glib-2.0', version: '>=2.32')
gobject = dependency('gobject-2.0', version: '>=2.32')
posix = meson.get_compiler('vala').find_library('posix')

# I18N START Configuration
conf = configuration_data()
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
configure_file(output: 'config.h', configuration: conf)
config_h_dir = include_directories('.')

c_args = [
  '-include', 'config.h',
]
# I18N END

subdir('data')
subdir('po')
subdir('src')
subdir('tests')

meson.add_install_script('meson-post-install.py')
