/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * radio-band.vala
 *
 * Radio band
 *
 * José Miguel Fonte
 */

public class RadioBand : Object {
    public string name {construct set; get;}
    public RadioFrequency begin {construct set; get;}
    public RadioFrequency end {construct set; get;}

    public RadioBand (string name, RadioFrequency begin, RadioFrequency end) requires (begin.get_frequency () < end.get_frequency ()) {
        this.name = name;
        this.begin = begin;
        this.end = end;
    }

    public bool contains (RadioFrequency freq) {
        double f = freq.get_frequency ();
        return f >= begin.get_frequency () && f <= end.get_frequency ();
    } 
}
