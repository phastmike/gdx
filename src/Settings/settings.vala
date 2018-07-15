/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * settings.vala
 * 
 * Singleton
 *
 */

public class Settings : Object {
    private GLib.Settings settings;
    private static Once<Settings> _instance;

    private string _user_callsign;
    private string _default_cluster_name;
    private string _default_cluster_address;
    private int _default_cluster_port;
    private string _default_cluster_login_script;
    private bool _auto_connect_startup;
    private bool _auto_reconnect;
    private bool _filter_spots_from_console;

    private Settings () {
        settings = new GLib.Settings ("org.ampr.ct1enq.gdx");

        _user_callsign = settings.get_string ("user-callsign");
        _default_cluster_name = settings.get_string ("default-cluster-name");
        _default_cluster_address = settings.get_string ("default-cluster-address");
        _default_cluster_port = settings.get_int ("default-cluster-port");
        _default_cluster_login_script = settings.get_string ("default-cluster-login-script");
        _auto_connect_startup = settings.get_boolean ("auto-connect-startup");
        _auto_reconnect = settings.get_boolean ("auto-reconnect");
        _filter_spots_from_console = settings.get_boolean ("filter-spots-from-console");
    }

    public static unowned Settings instance () {
        return _instance.once (() => {
            return new Settings ();
        });
    }

    public string user_callsign {
        get {
            return _user_callsign;
        }

        set {
            _user_callsign = value;
            settings.set_string ("user-callsign", value);
        }
    }

    public string default_cluster_name {
        get {
            return _default_cluster_name;
        }

        set {
            _default_cluster_name = value;
            settings.set_string ("default-cluster-name", value);
        }
    }

    public string default_cluster_address {
        get {
            return _default_cluster_address;
        }

        set {
            _default_cluster_address = value;
            settings.set_string ("default-cluster-address", value);
        }
    }

    public int default_cluster_port {
        get {
            return _default_cluster_port;
        }

        set {
            if (value >= 1 && value <= uint16.MAX) {
                _default_cluster_port = value;
                settings.set_int ("default-cluster-port", value);
            }
        }
    }

    public string default_cluster_login_script {
        get {
            return _default_cluster_login_script;
        }

        set {
            _default_cluster_login_script = value;
            settings.set_string ("default-cluster-login-script", value);
        }
    }

    public bool auto_connect_startup {
        get {
            return _auto_connect_startup;
        }

        set {
            _auto_connect_startup = value;
            settings.set_boolean ("auto-connect-startup", value);
        }
    }

    public bool auto_reconnect {
        get {
            return _auto_reconnect;
        }

        set {
            _auto_reconnect = value;
            settings.set_boolean ("auto-reconnect", value);
        }
    }

    public bool filter_spots_from_console {
        get {
            return _filter_spots_from_console;
        }

        set {
            _filter_spots_from_console = value;
            settings.set_boolean ("filter-spots-from-console", value);
        }
    }
}
