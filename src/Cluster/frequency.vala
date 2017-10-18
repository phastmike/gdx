/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * frequency.vala
 *
 * Jose Miguel Fonte, 2017
 */

public class Frequency : Object {
    double kHz;

    public Frequency () {
        kHz = 0.0;
    }

    public Frequency.from_string (string frequency) {
        // float parse method?
        kHz = double.parse (frequency);
    }
}
