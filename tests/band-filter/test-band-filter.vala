
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * test-radio-frequency.vala
 *
 */

using Gtk;
using GLib;

public int main (string[] args) {
    var band1 = new RadioBand ("20m", new RadioFrequency (14000.0), new RadioFrequency(14350.0));
    var band2 = new RadioBand ("10m", new RadioFrequency (28000.0), new RadioFrequency(29700.0));
    var band3 = new RadioBand ("40m", new RadioFrequency (7000.0), new RadioFrequency(7200.0));

    var filter1 = new BandFilter (band1);
    var filter2 = new BandFilter (band2);
    var filter3 = new BandFilter (band3);

    var filters = new BandFilters ();
    filters.add (filter1);
    filters.add (filter2);
    filters.add (filter3);

    assert (filters.check_frequency (new RadioFrequency (21250.0)) == false);
    assert (filters.check_frequency (new RadioFrequency (28250.0)) == true);
    assert (filters.check_frequency (new RadioFrequency (7150.0))  == true);
    assert (filters.check_frequency (new RadioFrequency (14350.0)) == true);
    assert (filters.check_frequency (new RadioFrequency (14350.1)) == false);
    assert (filters.check_frequency (new RadioFrequency (13999.9)) == false);

    return 0;
}

