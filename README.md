fluent-plugin-journal-parser
============================

What is this?
-------------

This is a [fluentd](https://www.fluentd.org/) parser plugin for parsing
the systemd [journal export format](https://www.freedesktop.org/wiki/Software/systemd/export/).

Usage
-----

Add this to your fluent.conf

```
<source>
  @type http
  port 8888
  format journal
</source>
```
and your boxes can push their journal to the server with

```sh
/lib/systemd/systemd-journal-upload -u http://myfluentdserver:8888/journal
```


A better solution is of course to edit your `/etc/systemd/journal-upload.conf` to add
the proper URL and run the daemon via services. Eg.:

```sh
systemctl enable systemd-journal-upload
systemctl start systemd-journal-upload
```
