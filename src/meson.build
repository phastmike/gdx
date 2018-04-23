# File definitions

share_action = files('ShareAction/share-action.vala',
    'ShareAction/share-action-spot.vala',
    'ShareAction/share-action-announcement.vala')
radio_frequency = files('Cluster/radio-frequency.vala')
radio_band = files('Cluster/radio-band.vala')
band_filter = files ('Cluster/band-filter.vala')
band_filters = files ('Cluster/band-filters.vala')


# Project sources

vala_sources = [
    'main.vala',
    'Application/application.vala',
    'Connector/connector.vala',
    'Cluster/dx-spot.vala',
    'Cluster/dx-cluster.vala',
    radio_band,
    #'Cluster/radio-band.vala',
    band_filter,
    band_filters,
    'Cluster/dx-clusters.vala',
    radio_frequency,
    'Parsers/iparsable.vala',
    'Parsers/parser-console.vala',
    share_action,
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

