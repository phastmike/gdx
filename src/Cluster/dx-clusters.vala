/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * dx-cluster.vala
 *
 * Copyright (C) 2017 José Miguel Fonte
 */

using Gee;

public class DXClusters {

    public static ArrayList<DXCluster> get_clusters () {
        var clusters = new ArrayList<DXCluster> ();

        // A reference to clusters list file
        var file = File.new_for_path ("../data/resources/clusters_combined_ve7cc_tested.txt");

        if (!file.query_exists ()) {
            stderr.printf ("File '%s' doesn't exist.\n", file.get_path ());
            return clusters;
        }

        try {
            // Open file for reading and wrap returned FileInputStream into a
            // DataInputStream, so we can read line by line
            var dis = new DataInputStream (file.read ());
            string line;
            // Read lines until end of file (null) is reached
            while ((line = dis.read_line (null)) != null) {
                //stdout.printf ("%s\n", line);
                string[] split = line.split (",", 0);
                clusters.add (new DXCluster.with_data (split[0], split[1], split[2]));
                foreach (unowned string s in split) {
                    stdout.printf ("[%s]", s);
                }
                print ("\n");
            }
        } catch (Error e) {
            error ("%s", e.message);
        }

        return clusters;
    }
}
