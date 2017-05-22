vala_sources = [
    'main.vala',
    'Application/application.vala',
    'Connector/connector.vala',
    'MainWindow/main-window.vala',
    'SpotWindow/spot-window.vala',
    'parser_text.vala',
]

vala_args = [
    '--target-glib=2.38',
    '--gresources=../data/org.ampr.ct1enq.gdx.gresource.xml',
]

valagtk = executable('gdx',
                     vala_sources,
                     resources,
                     vala_args: vala_args,
                     install: true,
                     dependencies : [glib, gobject, gio, gtk, posix])
