# php-mainline

Mainline Debian runtime for PHP using Sury's great packages from https://deb.sury.org

The image includes the CLI, CGI and FPM SAPIs, with minimal configuration changes (see below).

## Get started

TBD

## About versions

Image tags follow the `$PHP_VERSION-$DEBIAN_CODENAME[-$GIT_COMMIT_SHA7][-$BUILD_TIMESTAMP]` format; for example:

- 8.1
- 8.1-bullseye
- 8.1-bullseye-a12345f
- 8.1-bullseye-a12345f-202201082204

> Note that we don't run outdated PHP versions, and specifically track latest builds asap; that usually means on the
> week of their releases for minor and patch versions, and within 2-3 weeks of release for major versions. As a result
> this image will be as frequently updated.
>
> Feel free to fork your slower and CVE-ridden abandonware version if you like that better.

## About PECLs and modules

We build this image without any particular runtime modules. Mostly because there's a high chance you don't need the same
ones as us and will need to make a sub-image anyway.

## Snuffleupagus

On the other hand, this image contains and enables an up-to-date version
of [Snuffleupagus](https://github.com/jvoisin/snuffleupagus), which is essentially the successor of Suhosin, a
great set of virtual patches to PHP for defense-in-depth.
