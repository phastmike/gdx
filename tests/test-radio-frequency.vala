
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * test-radio-frequency.vala
 *
 */

using Gtk;

public int main (string args[]) {
    var frequency = new RadioFrequency.from_string ("");
    print ("Freq: %s\n", frequency.to_string ());
    var freq1 = new RadioFrequency (14005.3);
    var freq2 = new RadioFrequency.from_string ("14005.3");
    print ("Freq1 = Freq2 ? %s = %s ?\n", freq1.to_string (), freq2.to_string ());

    return 0;
}

