vala_sources = [
    'main.vala',
    'Application/application.vala',
    'Connector/connector.vala',
    'Cluster/dx-spot.vala',
    'Cluster/dx-cluster.vala',
    'Cluster/dx-clusters.vala',
    'Parsers/iparsable.vala',
    'Parsers/parser-console.vala',
    'Widgets/MainWindow/main-window.vala',
    'Widgets/SpotWindow/spot-window.vala',
    'Widgets/ShareWindow/share-window.vala',
    'Widgets/SettingsWindow/settings-window.vala',
    'Settings/settings.vala',
]

vala_args = [
    '--target-glib=2.38',
    '--gresources=../data/org.ampr.ct1enq.gdx.gresource.xml',
]

executable('gdx',
                     vala_sources,
                     resources,
                     c_args: c_args,
                     vala_args: vala_args,
                     install: true,
                     dependencies : [glib, gobject, gio, gee, gtk, posix])
