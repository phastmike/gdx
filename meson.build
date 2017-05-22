project('GDx', ['vala', 'c'],
        version: '1.0.0',
        meson_version: '>=0.29')

gio = dependency('gio-2.0', version: '>=2.32')
gtk = dependency('gtk+-3.0', version: '>=3.18')
glib = dependency('glib-2.0', version: '>=2.32')
gobject = dependency('gobject-2.0', version: '>=2.32')
posix = meson.get_compiler('vala').find_library('posix')


subdir('data')
subdir('src')
