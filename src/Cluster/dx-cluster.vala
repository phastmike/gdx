/* -*- Mode: Vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*- */
/* vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab : */
/*
 * dx-cluster.vala
 *
 * Copyright (C) 2017 José Miguel Fonte
 */

public class DXCluster : Object {
    public string call {set;get;default="";}
    public string address {set;get;default="";}
    public string port {set;get;default="";}

    public DXCluster.with_data (string call, string address, string port) {
        this.call = call;
        this.address = address;
        this.port = port;
    }
}