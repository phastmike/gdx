### TEST BAND FILTER ###

test_band_filter_sources = [
    'test-band-filter.vala',
	 radio_frequency,
	 radio_band,
	 radio_band_filter,
	 radio_band_filters,
]

test_band_filter = executable('test_band_filter',
                     test_band_filter_sources,
                     resources,
                     c_args: c_args,
                     vala_args: vala_args,
                     install: false,
                     dependencies : [glib, gobject, gio, gee, gtk, posix])

test('Test BandFilter', test_band_filter)
