/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * main.vala
 *
 */

int main (string[] args) {

    // Setup gettext
    Intl.bindtextdomain(Config.GETTEXT_PACKAGE, Config.GNOMELOCALEDIR);
    Intl.setlocale(LocaleCategory.ALL, "");
    Intl.textdomain(Config.GETTEXT_PACKAGE);
    Intl.bind_textdomain_codeset(Config.GETTEXT_PACKAGE, "utf-8");

    message("Locale dir: " + Config.GNOMELOCALEDIR);

    return new Application ().run (args);
}
