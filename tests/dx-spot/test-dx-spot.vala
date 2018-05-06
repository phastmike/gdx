
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * test-radio-frequency.vala
 *
 */

using Gtk;
using GLib;

public int main (string args[]) {
    var spot = new DxSpotBuilder ().
        add_spotter ("CT1ENQ").
        add_frequency ("14045.0").
        add_dx ("3Y0PI").
        add_comment ("Tnx new one").
        add_utc ("23:30").
        build ();

    assert (spot.spotter == "CT1ENQ");
    assert (spot.freq == "14045.0");
    assert (spot.dx == "3Y0PI");
    assert (spot.comment == "Tnx new one");
    assert (spot.utc == "23:30");

    return 0;
}

