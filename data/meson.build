gnome_module = import('gnome')

resources = gnome_module.compile_resources('org.ampr.ct1enq.gdx',
                                           'org.ampr.ct1enq.gdx.gresource.xml',
                                           source_dir: '.',
                                           c_name: 'resources')

# Settings Schema
install_data('org.ampr.ct1enq.gdx.gschema.xml', install_dir : join_paths(get_option('datadir'), 'glib-2.0', 'schemas'))
