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

