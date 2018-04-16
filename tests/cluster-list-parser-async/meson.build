### TEST CLUSTER LIST PARSER ASYNC ###

test_cluster_list_parser_async_sources = [
    'test-cluster-list-parser-async.vala',
]

test_cluster_list_parser_async = executable('test_cluster_list_parser_async',
                     test_cluster_list_parser_async_sources,
                     resources,
                     c_args: c_args,
                     vala_args: vala_args,
                     install: false,
                     dependencies : [glib, gobject, gio, gee, gtk, posix])

test('Test DXClusterList async', test_cluster_list_parser_async)
