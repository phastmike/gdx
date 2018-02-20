/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * band-filter.vala
 *
 * Radio band
 *
 * José Miguel Fonte
 */

 public class BandFilter : Object {
    Type type;
    bool status;
    public RadioBand band;

    public enum Type {
        ACCEPT,
        REJECT
    }

    public BandFilter (RadioBand band, bool status = true, Type type = Type.ACCEPT) {
        this.band = band;
        this.status = status;
        this.type = type;
    }
 }
