
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * test-radio-frequency.vala
 *
 */

using Gtk;
using GLib;

public int main (string args[]) {
    var spotter = "CT0AAA";
    var frequency = "14260.0";
    var dx = "3Y0PI";
    var comment = "No takers";
    var utc = "2230Z";

    var spot = new DxSpotBuilder ().
        add_spotter (spotter).
        add_frequency (frequency).
        add_dx (dx).
        add_comment (comment).
        add_utc (utc).
        build ();

    assert (spot.spotter == spotter);
    assert (spot.freq == frequency);
    assert (spot.dx == dx);
    assert (spot.comment == comment);
    assert (spot.utc == utc);

    return 0;
}

