/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab : */
/*
 * warehouse.vala
 *
 * Warehouse access.
 * 
 * user_data_dir on Fedora is $HOME/.local/share/
 *
 * Jose Miguel Fonte
 */

using Sqlite;

public class Warehouse : Object {
	private Sqlite.Database db;
	private File db_dir = File.new_for_path (Path.build_filename (Environment.get_user_data_dir (), "gdx"));
	private File db_file = File.new_for_path (Path.build_filename (Environment.get_user_data_dir (), "gdx", "gdx.db"));

	public RadioBandFilters band_filters; // if not static, crash on filter window

	construct {
		band_filters = null;
	}

	public Warehouse () {
		if (!database_exists ()) {
			create_database ();
			open_database ();
			init_database ();
		} else {
			open_database ();
		}
		
		band_filters = new RadioBandFilters ();
		read_config.begin ();
		read_radio_band_filters.begin ();
	}

	private bool database_exists () {
		return db_file.query_exists ();
	}

	private void create_database () {
		message ("Create database...");

		try {
			if (!database_exists ()) {
				if (!db_dir.query_exists ()) {
					db_dir.make_directory_with_parents ();
					db_dir.create (FileCreateFlags.NONE);
				}
			} else {
				warning ("Database already exists.");
			}

		} catch (Error e) {
			critical ("Cannot create new database file");
		}
	}

	private void open_database () {
		message("Open database...");
		message(db_file.get_path());

		int return_code = Sqlite.Database.open (db_file.get_path (), out db);
		if (return_code!= Sqlite.OK) {
			critical ("Can't open database: %d: %s\n", db.errcode (), db.errmsg ());
			return;
		}
	}

	private async void read_config () {
		message ("Reading config...");
		Statement stmt;
		
		int rc = 0;
		int cols;

		if ((rc = db.prepare_v2 ("SELECT * FROM Config", -1, out stmt, null)) == 1) {
			critical ("SQL error: %d, %s", rc, db.errmsg ());
		}

		cols = stmt.column_count ();
		
		do {
			rc = stmt.step ();
			switch (rc) {
				case Sqlite.DONE:
					break;
				case Sqlite.ROW:
					message ("Found config ...");
					band_filters.enabled = (bool) stmt.column_int (0);
					break;
				default:
					printerr ("Error: %d, %s\n", rc, db.errmsg ());
					break;
			}

		} while (rc == Sqlite.ROW);
		message ("Read Config...");
	}


	private async void read_radio_band_filters () {
		message ("Reading band filters...");
		Statement stmt;
		
		int rc = 0;
		int cols;

		if ((rc = db.prepare_v2 ("SELECT * FROM RadioBandFilters", -1, out stmt, null)) == 1) {
			critical ("SQL error: %d, %s<n", rc, db.errmsg ());
		}

		cols = stmt.column_count ();
		
		do {
			rc = stmt.step ();
			switch (rc) {
				case Sqlite.DONE:
					break;
				case Sqlite.ROW:
					message ("Found radio band filter: %s - %d (%s)...", stmt.column_text (1), stmt.column_int (2), stmt.column_text (4));
					var band = new RadioBand (stmt.column_text (1), new RadioFrequency (stmt.column_double (2)), new RadioFrequency (stmt.column_double (3)));
					var band_filter = new RadioBandFilter (band, (bool) stmt.column_int (4), RadioBandFilter.Type.ACCEPT, stmt.column_int (0)); 

					if (band_filter != null) {
						band_filters.add (band_filter); // add sorted?
					}
					break;
				default:
					printerr ("Error: %d, %s\n", rc, db.errmsg ());
					break;
			}

		} while (rc == Sqlite.ROW);
		message ("Read all filters...");
	}

	public bool save_config () {
		int rc;
		string err_msg;

		string query = "UPDATE Config SET enabled = %s ;".printf (band_filters.enabled ? "TRUE" : "FALSE");

		rc = db.exec (query, null, out err_msg);

		if (rc != Sqlite.OK) {
			critical ("Could not save config :: %s", err_msg);
			return false;
		} else {
			return true;
		} 
	}

	public bool save_radio_band_filter (RadioBandFilter filter) {
		int rc;
		string err_msg;

		string query = "UPDATE RadioBandFilters SET enabled = %s WHERE id = %u;".printf (filter.enabled ? "TRUE" : "FALSE", filter.id);

		rc = db.exec (query, null, out err_msg);

		if (rc != Sqlite.OK) {
			critical ("Could not save radio band filter %s :: %s", filter.band.name, err_msg);
			return false;
		} else {
			return true;
		} 
	}

	private void init_database () {
		string db_error_message;

		message ("Initialize database...");

		string sql_init = """
			CREATE TABLE Config (
				enabled BOOLEAN DEFAULT (0)
			);

			INSERT INTO Config (enabled) VALUES (0);
								
			CREATE TABLE RadioBandFilters (
    			id        INTEGER PRIMARY KEY ON CONFLICT ROLLBACK AUTOINCREMENT,
    			name      CHAR    NOT NULL,
    			freq_begin DECIMAL NOT NULL,
    			freq_end   DECIMAL NOT NULL,
    			enabled   BOOLEAN DEFAULT (0)
			);

			INSERT INTO RadioBandFilters (
                                 name,
                                 freq_begin,
                                 freq_end,
                                 enabled
                             )
                             VALUES (
                                 'VLF',
                                 1,
                                 1000,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 name,
                                 freq_begin,
                                 freq_end,
                                 enabled
                             )
                             VALUES (
                                 '160m',
                                 1800,
                                 2000,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 name,
                                 freq_begin,
                                 freq_end,
                                 enabled
                             )
                             VALUES (
                                 '80m',
                                 3500,
                                 4000,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 name,
                                 freq_begin,
                                 freq_end,
                                 enabled
                             )
                             VALUES (
                                 '60m',
                                 5350,
                                 5370,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 name,
                                 freq_begin,
                                 freq_end,
                                 enabled
                             )
                             VALUES (
                                 '40m',
                                 7000,
                                 7300,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 name,
                                 freq_begin,
                                 freq_end,
                                 enabled
                             )
                             VALUES (
                                 '30m',
                                 10000,
                                 10150,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 name,
                                 freq_begin,
                                 freq_end,
                                 enabled
                             )
                             VALUES (
                                 '20m',
                                 14000,
                                 14350,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 name,
                                 freq_begin,
                                 freq_end,
                                 enabled
                             )
                             VALUES (
                                 '17m',
                                 18068,
                                 18168,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 name,
                                 freq_begin,
                                 freq_end,
                                 enabled
                             )
                             VALUES (
                                 '15m',
                                 21000,
                                 21450,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 name,
                                 freq_begin,
                                 freq_end,
                                 enabled
                             )
                             VALUES (
                                 '12m',
                                 24890,
                                 24990,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 name,
                                 freq_begin,
                                 freq_end,
                                 enabled
                             )
                             VALUES (
                                 '10m',
                                 28000,
                                 29700,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 name,
                                 freq_begin,
                                 freq_end,
                                 enabled
                             )
                             VALUES (
                                 '6m',
                                 50000,
                                 54000,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 name,
                                 freq_begin,
                                 freq_end,
                                 enabled
                             )
                             VALUES (
                                 '70cm',
                                 420000,
                                 450000,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 name,
                                 freq_begin,
                                 freq_end,
                                 enabled
                             )
                             VALUES (
                                 '23cm',
                                 1240000,
                                 1300000,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 name,
                                 freq_begin,
                                 freq_end,
                                 enabled
                             )
                             VALUES (
                                 '12cm',
                                 2300000,
                                 2450000,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 name,
                                 freq_begin,
                                 freq_end,
                                 enabled
                             )
                             VALUES (
                                 'SHF',
                                 2500000,
                                 990000000,
                                 0
                             );
			""";

			int return_code = db.exec (sql_init, null, out db_error_message);
			if (return_code == Sqlite.OK) {
				message("Successfully initialized database!");
			} else {
				critical ("Could not initialize database: %s\n", db_error_message);
			}
	}
}
