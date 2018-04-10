
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * test-radio-frequency.vala
 *
 */

using Gtk;
using GLib;

public int main (string args[]) {
    var frequency = new RadioFrequency.from_string ("");
    assert (frequency.to_string () == "0");

    var freq1 = new RadioFrequency (14005.3);
    var freq2 = new RadioFrequency.from_string ("14005.3");
    assert (freq1.to_string () == freq2.to_string ());

    return 0;
}

