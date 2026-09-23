# HTTP client — calling a REST API from ABAP

**Level:** 201 · working knowledge

**Status:** stub — the API is here; the worked example is not yet.

**One line:** ABAP calls out over HTTP with `cl_http_client` (on-premise) or `cl_web_http_client_manager` (the released ABAP Cloud API), usually through an RFC destination of type `G`/`H` (`SM59`) that holds the host, the path prefix, the proxy and the credentials — so the code names the destination and never the URL, and the certificate lives in `STRUST`, not in the program.

## The shape (on-premise)

```abap
cl_http_client=>create_by_destination( EXPORTING destination = 'ZPARTNER_API'
                                       IMPORTING client = DATA(lo_client) ).
lo_client->request->set_method( if_http_request=>co_request_method_post ).
lo_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).
lo_client->request->set_cdata( lv_json ).
lo_client->send( ).
lo_client->receive( ).
DATA(lv_status) = lo_client->response->get_status( ).
DATA(lv_body)   = lo_client->response->get_cdata( ).
lo_client->close( ).
```

`send( )` and `receive( )` raise `cx_http_client_error` subclasses — the timeout, the connection refused, the TLS failure — and a non-2xx status is **not** an exception, so `get_status( )` has to be read. `create_by_url` exists and is what turns a program into a place credentials get hard-coded.

## The parts that are not code

- **`SM59`** destination: host, path prefix, proxy, SSL client identity, logon (basic, or none, or the OAuth profile).
- **`STRUST`**: the partner's certificate chain, imported into the SSL client PSE, without which every `https` call fails with a message that does not say "certificate".
- **`SMICM`**: the ICM trace, the tool that shows what actually went over the wire.
- **`STRUSTSSO2` / OAuth 2.0 client profiles** (`OA2C_CONFIG`): tokens, when basic auth is not enough.

## What this page still needs

- [ ] a `snippets/` program against a public test endpoint, via a destination, with status handling
- [ ] the `STRUST` import, once, with the error it fixes
- [ ] `cl_web_http_client_manager` beside the classic API, for cloud code
- [ ] the payload built and parsed with the [JSON tools](../json_and_xml/README.md)

## See also

- [JSON and XML](../json_and_xml/README.md) — the payload
- [Unicode and code pages](../unicode_and_code_pages/README.md) — `set_cdata` versus `set_data`, characters versus bytes
- [OData, Gateway and Fiori](../odata_and_fiori/README.md) — the other direction
- [Security](../security/README.md) — why the URL and the credentials are not in the code
