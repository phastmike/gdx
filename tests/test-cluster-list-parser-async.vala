using Gee;
using Gtk;

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

public class DXClusterList : Gee.ArrayList<DXCluster> {
    // A reference to clusters list file
    // FIX: Add resource | dowloadable? | Options?
    private const string filename = "../data/resources/clusters_combined_ve7cc_tested.txt";

    public async void add_from_file () {
        var file = File.new_for_path (filename);

        if (!file.query_exists ()) {
            stderr.printf ("File '%s' doesn't exist.\n", file.get_path ());
            return;
        }

        try {
            // Open file for reading and wrap returned FileInputStream into a
            // DataInputStream, so we can read line by line
            var dis = new DataInputStream (file.read ());
            string line;
            // Read lines until end of file (null) is reached
            while ((line = yield dis.read_line_async ()) != null) {
                //stdout.printf ("%s\n", line);
                string[] split = line.split (",", 0);
                this.add (new DXCluster (split[0], split[1], split[2]));
                /*
                foreach (unowned string s in split) {
                    stdout.printf ("[%s]", s);
                }
                print ("\n");
                */
            }
        } catch (Error e) {
            error ("%s", e.message);
        }
    }
}

int main (string[] args) {
    int idle_cycles = 0;
    Gtk.init(ref args);

    var list = new DXClusterList ();

    list.add_from_file.begin ((obj, res) => {
        DXClusterList clusters = (DXClusterList) obj;
        clusters.add_from_file.end (res);
        /*
        foreach (DXCluster cluster in clusters) {
            stdout.printf ("%s [%s:%s]\n", cluster.call, cluster.address, cluster.port);
        }
        */
        Gtk.main_quit ();
    });

    Idle.add (() => {
        idle_cycles += 1;
        return true;
    });

    Gtk.main ();
    
    print ("*** Number of idle cycles: %d\n", idle_cycles);
    print ("*** Number of clusters in list: %d\n", list.size);

    return 0;
}
