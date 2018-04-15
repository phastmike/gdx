/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * band-filters.vala
 *
 * José Miguel Fonte
 */

using Gee;

public class BandFilters : ArrayList<BandFilter> {
    public bool enabled = true;

    public bool check_frequency (RadioFrequency freq) {
        foreach (var bf in this) {
            if (bf.enabled && bf.filter (freq)) {
                return true; 
            }
        }
        return (false);
    }
    
}
