/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * frequency.vala
 * 
 * Frequency as kHz.
 * Clusters use frequencies in kHz so it makes sense to use the same multiple
 * and avoid unnecessary conversions.
 *
 * José Miguel Fonte
 */

public class RadioFrequency : Object {
    double kHz;
    Multiples multiple;

    enum Multiples {
        Hz  = 0,
        kHz = 3,
        MHz = 6,
        GHz = 9,
        THz = 12
    }

    construct {
        multiple = Multiples.kHz;
    }

    public RadioFrequency (double frequency = 0.0) {
        kHz = frequency;
    }

    public RadioFrequency.from_string (string frequency) {
        kHz = double.parse (frequency);
    }

    public string to_string () {
        return kHz.to_string ();
    }
}
