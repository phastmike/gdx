### TEST DXSPOT AND SPOT BUILDER ###

test_dx_spot_sources = [
    'test-dx-spot.vala',
	 dx_spot,
]

test_dx_spot = executable('test_dx_spot',
                     test_dx_spot_sources,
                     resources,
                     c_args: c_args,
                     vala_args: vala_args,
                     install: false,
                     dependencies : [glib, gobject, gio, gee, gtk, posix])

test('Test DxSpot and DxSpotBuilder', test_dx_spot)

