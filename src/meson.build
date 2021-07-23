# File definitions

dx_spot = files ('Cluster/dx-spot.vala')
share_action = files('ShareAction/share-action.vala',
    'ShareAction/share-action-spot.vala',
    'ShareAction/share-action-announcement.vala')
radio_band = files('Cluster/radio-band.vala')
radio_band_filter = files ('Cluster/radio-band-filter.vala')
radio_band_filters = files ('Cluster/radio-band-filters.vala')
radio_frequency = files('Cluster/radio-frequency.vala')
warehouse = files('Warehouse/warehouse.vala')


# Project sources

vala_sources = [
    'main.vala',
    'Application/application.vala',
    'Connector/connector.vala',
    'Cluster/dx-spot.vala',
    'Cluster/dx-cluster.vala',
    radio_band,
    radio_band_filter,
    radio_band_filters,
    'Cluster/dx-clusters.vala',
    radio_frequency,
    'Parsers/iparsable.vala',
    'Parsers/parser-console.vala',
    share_action,
    'Widgets/MainWindow/main-window.vala',
    'Widgets/FilterWindow/filter-window.vala',
    'Widgets/ShareWindow/share-window.vala',
    'Widgets/ShareWindow/shareable-view.vala',
    'Widgets/ShareWindow/share-spot-view.vala',
    'Widgets/ShareWindow/share-announcement-view.vala',
    'Widgets/SettingsWindow/settings-window.vala',
    'Widgets/AppNotification/app-notification.vala',
    'Settings/settings.vala',
    warehouse,
]

vala_args = [
    '--target-glib=2.38',
    '--pkg=config',
    '--vapidir=' + meson.current_source_dir() + '/vapi',
    #'--gresources=../data/org.ampr.ct1enq.gdx.gresource.xml',
]

executable('gdx',
            vala_sources,
            resources,
            c_args: c_args,
            vala_args: vala_args,
            install: true,
            dependencies : [glib, gobject, gio, gee, gtk, posix, sqlite3])

