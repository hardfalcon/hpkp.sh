# hpkp.sh

hpkp.sh is a simple shellscript which generates a HPKP header from one or more PEM certificates.

### Usage

```sh
$ ./hpkp.sh certificate1.pem certificate2.pem certificate3.pem
```

The script just outputs the bare HTTP header as it would be sent by the webserver. You may have to adapt this depending on the webserver you are using (i.e. escape quotes if you are using the Apache HTTP Server). The script generates a HPKP header with a hardcoded lifetime of 60 days and the includeSubDomains.

Caution: Only configure a HPKP header on your webserver if you know what you are doing. You can easily make your entire DNS zone (including all subdomains) completely useless for HTTPS or even HTTP usage if you send the wrong HPKP header. Be sure to read RFC 7469 in its entirety *before* trying out HPKP!

### System requirements

The script relies upon OpenSSL and should be POSIX compliant, thus hopefully being able to run on most unixoid operating systems.

### Licensing

hpkp.sh is (C) 2016 by Pascal Ernster.

hpkp.sh is licensed under the GNU General Public License v3.0.

