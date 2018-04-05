
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * test-radio-frequency.vala
 *
 */

using Gtk;

public int main (string args[]) {
    var frequency = new RadioFrequency.from_string ("");
    print ("Freq: %s\n", frequency.to_string ());
    var frequency2 = new RadioFrequency.from_string (null);
    print ("Freq: %s\n", frequency2.to_string ());
    return 0;
}

