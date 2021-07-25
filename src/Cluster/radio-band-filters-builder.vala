/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * band-filters.vala
 *
 * José Miguel Fonte
 */

public class RadioBandFiltersBuilder : RadioBandFilters {
    public RadioBandFiltersBuilder () {
        add(new RadioBandFilter (
            new RadioBand ("160m",
            new RadioFrequency (1800.0),
            new RadioFrequency (2000.0))));
        add(new RadioBandFilter (
            new RadioBand ("80m",
            new RadioFrequency (3500.0),
            new RadioFrequency (4000.0))));
        add(new RadioBandFilter (
            new RadioBand ("60m",
            new RadioFrequency (5350.0),
            new RadioFrequency (5370.0))));
        add(new RadioBandFilter (
            new RadioBand ("40m",
            new RadioFrequency (7000.0),
            new RadioFrequency (7300.0))));
        add(new RadioBandFilter (
            new RadioBand ("30m",
            new RadioFrequency (10000.0),
            new RadioFrequency (10150.0))));
        add(new RadioBandFilter (
            new RadioBand ("20m",
            new RadioFrequency (14000.0),
            new RadioFrequency (14350.0))));
        add(new RadioBandFilter (
            new RadioBand ("17m",
            new RadioFrequency (18068.0),
            new RadioFrequency (18168.0))));
        add(new RadioBandFilter (
            new RadioBand ("15m",
            new RadioFrequency (21000.0),
            new RadioFrequency (21450.0))));
        add(new RadioBandFilter (
            new RadioBand ("12m",
            new RadioFrequency (24890.0),
            new RadioFrequency (24990.0))));
        add(new RadioBandFilter (
            new RadioBand ("10m",
            new RadioFrequency (28000.0),
            new RadioFrequency (29700.0))));
        add(new RadioBandFilter (
            new RadioBand ("6m",
            new RadioFrequency (50000.0),
            new RadioFrequency (54000.0))));
        add(new RadioBandFilter (
            new RadioBand ("4m",
            new RadioFrequency (69900.0),
            new RadioFrequency (70500.0))));
        add(new RadioBandFilter (
            new RadioBand ("2m",
            new RadioFrequency (144000.0),
            new RadioFrequency (148000.0))));
        add(new RadioBandFilter (
            new RadioBand ("70cm",
            new RadioFrequency (420000.0),
            new RadioFrequency (450000.0))));
        add(new RadioBandFilter (
            new RadioBand ("23cm",
            new RadioFrequency (1240000.0),
            new RadioFrequency (1300000.0))));
        add(new RadioBandFilter (
            new RadioBand ("12cm",
            new RadioFrequency (2300000.0),
            new RadioFrequency (2450000.0))));
    }
}

