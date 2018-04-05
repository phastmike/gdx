# File definitions

share_action = files('ShareAction/share-action.vala',
	'ShareAction/share-action-spot.vala',
	'ShareAction/share-action-announcement.vala')
radio_frequency = files('Cluster/radio-frequency.vala')


# Project sources

vala_sources = [
    'main.vala',
    'Application/application.vala',
    'Connector/connector.vala',
    'Cluster/dx-spot.vala',
    'Cluster/dx-cluster.vala',
    'Cluster/radio-band.vala',
    'Cluster/band-filter.vala',
    'Cluster/dx-clusters.vala',
	 radio_frequency,
    'Parsers/iparsable.vala',
    'Parsers/parser-console.vala',
	 share_action,
    #'ShareAction/share-action.vala',
    #'ShareAction/share-action-spot.vala',
    #'ShareAction/share-action-announcement.vala',
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

# Unit tests

#test_radio_frequency_sources = [
#    'tests/test_radio_frequency.vala',
#    'Cluster/radio-frequency.vala',
#]

#test1 = executable('test1',
#                     test_radio_frequency_sources,
#                     resources,
#                     c_args: c_args,
#                     vala_args: vala_args,
#                     install: false,
#                     dependencies : [glib, gobject, gio, gee, gtk, posix])

#test('Test RadioFrequency', test1)

#test_share_action_sources = [
#    'tests/test-share-action.vala',
#    'ShareAction/share-action.vala',
#    'ShareAction/share-action-spot.vala',
#    'ShareAction/share-action-announcement.vala',
#]

#test2 = executable('test2',
#                     test_share_action_sources,
#                     resources,
#                     c_args: c_args,
#                     vala_args: vala_args,
#                     install: false,
#                     dependencies : [glib, gobject, gio, gee, gtk, posix])

#test('Test ShareActions', test2)
