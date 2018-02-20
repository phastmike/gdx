vala_sources = [
    'main.vala',
    'Application/application.vala',
    'Connector/connector.vala',
    'Cluster/dx-spot.vala',
    'Cluster/dx-cluster.vala',
    'Cluster/radio-band.vala',
    'Cluster/band-filter.vala',
    'Cluster/dx-clusters.vala',
    'Cluster/radio-frequency.vala',
    'Parsers/iparsable.vala',
    'Parsers/parser-console.vala',
    'ShareAction/share-action.vala',
    'ShareAction/share-action-spot.vala',
    'ShareAction/share-action-announcement.vala',
    'Widgets/MainWindow/main-window.vala',
    'Widgets/FilterWindow/filter-window.vala',
    'Widgets/SpotWindow/spot-window.vala',
    'Widgets/ShareWindow/share-window.vala',
    'Widgets/SettingsWindow/settings-window.vala',
    'Widgets/AppNotification/app-notification.vala',
    'Settings/settings.vala',
]

vala_args = [
    '--target-glib=2.38',
    #'--gresources=../data/org.ampr.ct1enq.gdx.gresource.xml',
]

executable('gdx',
                     vala_sources,
                     resources,
                     c_args: c_args,
                     vala_args: vala_args,
                     install: true,
                     dependencies : [glib, gobject, gio, gee, gtk, posix])
