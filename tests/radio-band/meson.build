### TEST RADIO BAND ###

test_radio_band_sources = [
    'test-radio-band.vala',
	 radio_frequency,
	 radio_band,
]

test_radio_band = executable('test_radio_band',
                     test_radio_band_sources,
                     resources,
                     c_args: c_args,
                     vala_args: vala_args,
                     install: false,
                     dependencies : [glib, gobject, gio, gee, gtk, posix])

test('Test RadioBand', test_radio_band)

