# Fogstore
Community decentralized storage at hand.

## Security, decentralization, open source
Fogstore wants to provide an easy way to deploy xtreemfs filesystem,
with strong SSL configuration and access controls.

### Xtreemfs?
XtreemFS is a general purpose storage system and covers most storage needs
in a single deployment. It is open-source, requires no special hardware
or kernel modules, and can be mounted on Linux, Windows and OS X.

XtreemFS is easy to setup and administer, and requires you to maintain fewer
storage systems.

[More information](http://xtreemfs.org/)

### Why such a project?
Currently, if we want some storage, either we buy hard drives (and related things
like a new computer, NAS and so on), or we buy storage provided by a service such
as Google Drive, DropBox.

With Fogstore, you buy storage and are allowed to create a grid. With your own storage,
or gathering with friends in order to get a more scalable, reliable and fault-tolerant
system.

### You said "easy"…?
This repository provides a puppet module. Basically, it's a wrapper for the following
"main" modules:

* [puppet-xtreemfs](https://github.com/wavesoftware/puppet-xtreemfs)
* [puppet-openssl](https://github.com/camptocamp/puppet-openssl)
* [puppetlabs-java_ks](https://github.com/puppetlabs/puppetlabs-java_ks)

Fogstore just provides helpers in order to access those modules and ensure you can
use them in a convenient way. You might as well take those modules and create your
own bunch of wrappers — there is almost no intelligence in Fogstore.

We will also provide some scripts allowing you to deploy a new OSD (storage) in a few
minutes. This part will be the most important of the whole project, as this will allow
anyone you want to join your own grid.

### Getting started
Coming soon ;).

Please check [the website](https://fogstore.org/) for more information.

