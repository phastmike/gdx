#!/usr/bin/env python3

from os import environ, path
from subprocess import call

prefix = environ.get('MESON_INSTALL_PREFIX', '/usr/local')
datadir = path.join(prefix, 'share')
destdir = environ.get('DESTDIR', '')

schemadir = path.join(environ['MESON_INSTALL_PREFIX'], 'share', 'glib-2.0', 'schemas')

if not destdir:
        print('Updating icon cache...')
        call(['gtk-update-icon-cache', '-qtf', path.join(datadir, 'icons', 'hicolor')])

        print('Updating desktop database...')
        call(['update-desktop-database', '-q', path.join(datadir, 'applications')])

        print('Compiling gsettings schemas...')
        call(['glib-compile-schemas', schemadir], shell=False)
