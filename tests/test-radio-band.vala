
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * test-radio-frequency.vala
 *
 */

using Gtk;
using GLib;

public int main (string args[]) {
    var band = new RadioBand ("20m", new RadioFrequency (14000.0), new RadioFrequency(14350.0));
    assert (band.contains (new RadioFrequency (14200.0)) == true);

    return 0;
}

