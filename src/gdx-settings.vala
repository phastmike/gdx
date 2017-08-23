/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * gdx-settings.vala
 *
 * Jose Miguel Fonte, 2017
 */

namespace Gdx {
    public class Settings : Object {
        private static GLib.Settings settings;

        private static string _user_callsign;
        private static string _default_cluster_name;
        private static string _default_cluster_address;
        private static int _default_cluster_port;
        private static string _default_cluster_login_script;
        private static bool _autoconnect_startup;
        private static bool _autoreconnect;

        static construct {
            settings = new GLib.Settings ("org.ampr.ct1enq.gdx");

            _user_callsign = settings.get_string ("user-callsign");
            _default_cluster_name = settings.get_string ("default-cluster-name");
            _default_cluster_address = settings.get_string ("default-cluster-address");
            _default_cluster_port = settings.get_int ("default-cluster-port");
            _default_cluster_login_script = settings.get_string ("default-cluster-login-script");
            _autoconnect_startup = settings.get_boolean ("autoconnect-startup");
            _autoreconnect = settings.get_boolean ("autoreconnect");
        }

        public static string user_callsign {
            get {
                return _user_callsign;
            }

            set {
                user_callsign = value;
                settings.set_string ("user_callsign", value);
            }
        }

        public static string default_cluster_name {
            get {
                return _default_cluster_name;
            }

            set {
                _default_cluster_name = value;
                settings.set_string ("default-cluster-name", value);
            }
        }

        public static string default_cluster_address {
            get {
                return _default_cluster_address;
            }

            set {
                _default_cluster_address = value;
                settings.set_string ("default-cluster-address", value);
            }
        }

        public static int default_cluster_port {
            get {
                return _default_cluster_port;
            }

            set {
                if (value >= 0 && value <= int16.MAX) {
                    _default_cluster_port = value;
                    settings.set_int ("default-cluster-port", value);
                }
            }
        }

        public static string default_cluster_login_script {
            get {
                return _default_cluster_login_script;
            }

            set {
                _default_cluster_login_script = value;
                settings.set_string ("default-cluster-login-script", value);
            }
        }

        public static bool autoconnect_startup {
            get {
                return _autoconnect_startup;
            }

            set {
                _autoconnect_startup = value;
                settings.set_boolean ("autoconnect-startup", value);
            }
        }

        public static bool autoreconnect {
            get {
                return _autoreconnect;
            }

            set {
                _autoreconnect = value;
                settings.set_boolean ("autoreconnect", value);
            }
        }
    }
}
