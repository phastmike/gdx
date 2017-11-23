using Gee;

public class DXCluster : Object {
    public string call;
    public string address;
    public string port;

    public DXCluster (string call, string address, string port) {
        this.call = call;
        this.address = address;
        this.port = port;
    }
}

public class DXClustersParser {

    public static ArrayList<DXCluster> get_clusters () {
        var clusters = new ArrayList<DXCluster> ();

        // A reference to clusters list file
        // FIX: Add resource | dowloadable? | Options?
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
                clusters.add (new DXCluster (split[0], split[1], split[2]));
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

int main () {
    var clusters = DXClustersParser.get_clusters ();
    foreach (DXCluster cluster in clusters) {
        stdout.printf ("%s [%s:%s]\n", cluster.call, cluster.address, cluster.port);
    }

    return 0;
}