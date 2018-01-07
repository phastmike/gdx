/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * radio-band.vala
 *
 * Radio band
 *
 */

public class RadioBand {
    string name;
    Frequency begin;
    Frequency end;

    public RadioBand (string name, Frequency begin, Frequency end) {
        this.name = name;
        this.begin = begin;
        this.end = end;
    }

}