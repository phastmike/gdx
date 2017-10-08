gnome_module = import('gnome')

resources = gnome_module.compile_resources('org.ampr.ct1enq.gdx',
                                           'org.ampr.ct1enq.gdx.gresource.xml',
                                           source_dir: '.',
                                           c_name: 'resources')

# Translate and install appdata and desktop file #
i18n.merge_file(
	input:  'org.ampr.ct1enq.gdx.desktop.in',
	output: 'org.ampr.ct1enq.gdx.desktop',
	po_dir: '../po/',
	type:   'desktop',
	install: true,
	install_dir: join_paths(get_option('datadir'), 'applications')
)


i18n.merge_file(
  input:  'org.ampr.ct1enq.gdx.appdata.xml.in',
  output: 'org.ampr.ct1enq.gdx.appdata.xml',
  po_dir: '../po/',
  type:   'xml',
  install: true,
  install_dir: join_paths(get_option('datadir'), 'appdata')
)

# Settings Schema
install_data('org.ampr.ct1enq.gdx.gschema.xml', install_dir : join_paths(get_option('datadir'), 'glib-2.0', 'schemas'))


# Icons #
icondir = join_paths(get_option('datadir'), 'icons', 'hicolor')
icon_sizes = ['16x16', '24x24', '32x32', '48x48', '256x256', '512x512']

foreach size : icon_sizes
	install_data('icons/hicolor/@0@/apps/org.ampr.ct1enq.gdx.png'.format(size), install_dir : join_paths(icondir, size, 'apps'))
endforeach

install_data('icons/hicolor/scalable/apps/org.ampr.ct1enq.gdx.svg', install_dir : 'share/icons/hicolor/scalable/apps')
install_data('icons/hicolor/scalable/apps/org.ampr.ct1enq.gdx-symbolic.svg', install_dir : 'share/icons/hicolor/symbolic/apps')

