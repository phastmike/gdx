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

