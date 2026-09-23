# Email from ABAP — `cl_bcs`, `SOST`, and why nothing arrived

**Level:** 201 · working knowledge

**Status:** stub — the API is here; the worked example is not yet.

**One line:** Sending mail is the Business Communication Services classes — `cl_bcs` for the send request, `cl_document_bcs` for the body and attachments, `cl_cam_address_bcs` for recipients — and the mail is only *queued* until `COMMIT WORK`, after which `SOST` shows whether SAPconnect (`SCOT`) actually delivered it, which it did not if nobody configured the SMTP node.

## The shape

```abap
DATA(lo_send) = cl_bcs=>create_persistent( ).
DATA(lo_doc)  = cl_document_bcs=>create_document(
  i_type = 'HTM' i_subject = 'Invoice 4711' i_text = lt_html ).
lo_doc->add_attachment( i_attachment_type = 'PDF' i_attachment_subject = 'invoice' i_att_content_hex = lt_pdf ).
lo_send->set_document( lo_doc ).
lo_send->add_recipient( cl_cam_address_bcs=>create_internet_address( 'ap@example.com' ) ).
lo_send->set_send_immediately( abap_true ).
lo_send->send( ).
COMMIT WORK.
```

Every step raises `cx_bcs`, a class-based exception worth catching for its `error_type`. The `COMMIT WORK` is not optional: without it the request is rolled back with the LUW, silently.

## The diagnosis order when nothing arrives

1. `SOST` — is the mail there, and with what status? *Waiting* means the send job (`RSCONN01`) has not run; *error* has a text.
2. `SCOT` — is there an SMTP node, and does the address domain route to it?
3. `SU01` of the sending user — does it have an email address? Some configurations refuse a sender without one.
4. The receiving side's spam filter, which is not an ABAP question and is the answer a third of the time.

## What this page still needs

- [ ] a `snippets/` program sending a plain text mail, with the `cx_bcs` handling
- [ ] `SOST` and `SCOT` screens for one delivery, recorded
- [ ] attachments from a Smart Form PDF, end to end

## See also

- [Forms and printing](../forms_and_printing/README.md) — where the PDF comes from
- [`COMMIT WORK`](../../02_Keywords/commit_work/README.md) — the commit that sends it
- [Background jobs](../background_jobs/README.md) — where most mails are sent from
- [Exceptions](../exceptions/README.md) — `cx_bcs`
