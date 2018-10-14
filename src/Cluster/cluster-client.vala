/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * cluster-client.vala
 *
 * José Miguel Fonte
 */

public class ClusterClient.Telnet: Object {
    public Connector connector; 
    public ParserConsole parser_console;

    public ClusterClient () {
        connector = new Connector ();
        parser_console = new ParserConsole
    }
}

