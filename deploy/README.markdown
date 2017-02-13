# Secretary Deployment

This is an Ansible playbook for deploying secretary to a CentOS or RHEL-like
server.

These plays are written assuming they are being run as the `root` user.
Presently, you must specify a `release_version` value, which can be learned
from `/VERSION` if you wish to find a way to automate that.

A file named `./inventory` is VCS-ignored in this directory, allowing you to
place your inventory file at that location if you desire. Then simply run:

```
$ ansible-playbook -i inventory deploy.yml
```

This also assumes a release has been generated. Before deploying, make sure
you have run `mix release` on a RHEL-like operating system and the tarball
is present at `./rel/secretary/$VERSION/secretary.tar.gz`
