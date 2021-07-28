/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * band-filters.vala
 *
 * José Miguel Fonte
 */

using Gee;

public class RadioBandFilters : ArrayList<RadioBandFilter> {
    public bool enabled {set; get; default = true;}

    public bool check_frequency (RadioFrequency freq) {
        foreach (var band_filter in this) {
            if (band_filter.enabled && band_filter.filter (freq)) {
                return true; 
            }
        }
        return (false);
    }
}


