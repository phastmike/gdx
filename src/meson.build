vala_sources = [
    'main.vala',
    'gdx-settings.vala',
    'Application/application.vala',
    'Connector/connector.vala',
    'Cluster/parser-text.vala',
    'Cluster/dx-spot.vala',
    'Cluster/iparsable.vala',
    'Cluster/dx-cluster.vala',
    'Cluster/dx-clusters.vala',
    'ui/MainWindow/main-window.vala',
    'ui/SpotWindow/spot-window.vala',
    'ui/SettingsWindow/settings-window.vala',
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
                     dependencies : [glib, gobject, gio, gee, gtk, posix])
