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
	Sqlite.Database db;
	File db_dir = File.new_for_path (Path.build_filename (Environment.get_user_data_dir (), "gdx"));
	File db_file = File.new_for_path (Path.build_filename (Environment.get_user_data_dir (), "gdx", "gdx.db"));

	public Warehouse () {
		if (!database_exists ()) {
			create_database ();
			open_database ();
			init_database ();
		} else {
			open_database ();
		}
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

	private void init_database () {
		string db_error_message;

		message ("Initialize database...");

		string sql_init = """
			CREATE TABLE RadioBandFilters (
    			id        INTEGER PRIMARY KEY ON CONFLICT ROLLBACK AUTOINCREMENT,
    			name      CHAR    NOT NULL,
    			freq_begin DECIMAL NOT NULL,
    			freq_end   DECIMAL NOT NULL,
    			enabled   BOOLEAN DEFAULT (0)
			);

			INSERT INTO RadioBandFilters (
                                 id,
                                 name,
                                 FreqBegin,
                                 FreqEnd,
                                 enabled
                             )
                             VALUES (
                                 1,
                                 '160m',
                                 1800,
                                 2000,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 id,
                                 name,
                                 FreqBegin,
                                 FreqEnd,
                                 enabled
                             )
                             VALUES (
                                 2,
                                 '80m',
                                 3500,
                                 4000,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 id,
                                 name,
                                 FreqBegin,
                                 FreqEnd,
                                 enabled
                             )
                             VALUES (
                                 3,
                                 '60m',
                                 5350,
                                 5370,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 id,
                                 name,
                                 FreqBegin,
                                 FreqEnd,
                                 enabled
                             )
                             VALUES (
                                 4,
                                 '40m',
                                 7000,
                                 7300,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 id,
                                 name,
                                 FreqBegin,
                                 FreqEnd,
                                 enabled
                             )
                             VALUES (
                                 5,
                                 '30m',
                                 10000,
                                 10150,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 id,
                                 name,
                                 FreqBegin,
                                 FreqEnd,
                                 enabled
                             )
                             VALUES (
                                 6,
                                 '20m',
                                 14000,
                                 14350,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 id,
                                 name,
                                 FreqBegin,
                                 FreqEnd,
                                 enabled
                             )
                             VALUES (
                                 7,
                                 '17m',
                                 18068,
                                 10168,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 id,
                                 name,
                                 FreqBegin,
                                 FreqEnd,
                                 enabled
                             )
                             VALUES (
                                 8,
                                 '15m',
                                 21000,
                                 21450,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 id,
                                 name,
                                 FreqBegin,
                                 FreqEnd,
                                 enabled
                             )
                             VALUES (
                                 9,
                                 '12m',
                                 24890,
                                 24990,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 id,
                                 name,
                                 FreqBegin,
                                 FreqEnd,
                                 enabled
                             )
                             VALUES (
                                 10,
                                 '10m',
                                 28000,
                                 29700,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 id,
                                 name,
                                 FreqBegin,
                                 FreqEnd,
                                 enabled
                             )
                             VALUES (
                                 11,
                                 '6m',
                                 50000,
                                 54000,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 id,
                                 name,
                                 FreqBegin,
                                 FreqEnd,
                                 enabled
                             )
                             VALUES (
                                 12,
                                 '70cm',
                                 420000,
                                 450000,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 id,
                                 name,
                                 FreqBegin,
                                 FreqEnd,
                                 enabled
                             )
                             VALUES (
                                 13,
                                 '23cm',
                                 1240000,
                                 1300000,
                                 0
                             );

			INSERT INTO RadioBandFilters (
                                 id,
                                 name,
                                 FreqBegin,
                                 FreqEnd,
                                 enabled
                             )
                             VALUES (
                                 14,
                                 '12cm',
                                 2300000,
                                 2450000,
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
