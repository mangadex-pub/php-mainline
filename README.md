# php-mainline

Mainline Debian runtime for PHP using Sury's great packages from https://deb.sury.org

The image includes the CLI, CGI and FPM SAPIs, with minimal configuration changes (see below).

## Get started

TBD

## About versions

Image tags are as follows:

- $PHP_VERSION
- $PHP_VERSION-$DEBIAN_CODENAME
- $PHP_VERSION-$DEBIAN_CODENAME-$GIT_SHA
- $GIT_BRANCH_NAME-$PHP_VERSION-$DEBIAN_CODENAME-$GIT_SHA

For example:

- 8.3
- 8.3-bookworm
- 8.3-bookworm-a12345f
- branch-main-8.3-bookworm-a12345f

> Note that we don't run outdated PHP versions, and specifically track latest builds asap; that usually means on the
> week of their releases for minor and patch versions, and within 2-3 weeks of release for major versions if at all
> possible with regards to third-party dependencies. As a result this image will be as frequently updated.
>
> Feel free to fork your own CVE-ridden abandonware version if you like that better.

## About PECLs and modules

We build this image without any particular runtime modules. Mostly because there's a high chance you don't need the same
ones as us and will need to make a sub-image anyway.

## Snuffleupagus

On the other hand, this image contains and enables an up-to-date version
of [Snuffleupagus](https://github.com/jvoisin/snuffleupagus), which is essentially the successor of Suhosin, a set of
runtime patches to PHP for defense-in-depth.
