### TEST SHARE ACTION CLASSES ###

test_share_action_sources = [
    'test-share-action.vala',
	 share_action,
]

test_share_action = executable('test_share_action',
                     test_share_action_sources,
                     resources,
                     c_args: c_args,
                     vala_args: vala_args,
                     install: false,
                     dependencies : [glib, gobject, gio, gee, gtk, posix])

test('Test Share Action', test_share_action)

### TEST RADIO FREQUENCY CLASS ###

test_radio_frequency_sources = [
    'test-radio-frequency.vala',
	 radio_frequency,
]

test_radio_frequency = executable('test_radio_frequency',
                     test_radio_frequency_sources,
                     resources,
                     c_args: c_args,
                     vala_args: vala_args,
                     install: false,
                     dependencies : [glib, gobject, gio, gee, gtk, posix])

test('Test RadioFrequency', test_radio_frequency)

### TEST CLUSTER LIST PARSER ASYNC ###

test_cluster_list_parser_async_sources = [
    'test-cluster-list-parser-async.vala',
]

test_cluster_list_parser_async = executable('test_cluster_list_parser_async',
                     test_cluster_list_parser_async_sources,
                     resources,
                     c_args: c_args,
                     vala_args: vala_args,
                     install: false,
                     dependencies : [glib, gobject, gio, gee, gtk, posix])

test('Test DXClusterList async', test_cluster_list_parser_async)
