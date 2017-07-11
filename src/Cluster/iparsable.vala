public interface IParsable : GLib.Object {
    public signal void rcvd_spot (DxSpot spot);

    public abstract void parse_spot (string text);
}
