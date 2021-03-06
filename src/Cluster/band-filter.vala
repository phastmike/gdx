/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * band-filter.vala
 *
 * José Miguel Fonte
 */

public class BandFilter : Object {
    public Type type;
    public bool enabled;
    public RadioBand band;

    public enum Type {
        ACCEPT,
        REJECT
    }

    public BandFilter (RadioBand band, bool enabled = true, Type type = Type.ACCEPT) {
        this.band = band;
        this.enabled = enabled;
        this.type = type;
    }

    public bool filter (RadioFrequency frequency) {
        return this.band.contains (frequency);
    }
}
