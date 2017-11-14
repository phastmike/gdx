/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * iconnectable.vala
 *
 * Jose Miguel Fonte, 2017
 *
 */

public interface IConnectable : Object {
    public abstract async void connect_async (string host, uint16 port);
    public abstract void disconnect_async ();
    public abstract bool reconnect ();
    public abstract void send (string msg);
    public abstract void receive_async ();
    public abstract void message_handler (string msg);
}
