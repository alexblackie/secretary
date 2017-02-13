# Secretary

[![Build Status](https://ci.blackieops.com/buildStatus/icon?job=secretary-tests)](https://ci.blackieops.com/job/secretary-tests/)

I like branch categories. What I realised I would also like is if my pull
requests in Github were filterable based on that category. This is a small
webhook--ahem--"microservice" to consume github webhooks and then label newly
opened PRs with a label that matches their branch category.

![Screenshot of the result](./.preview.png)

## Development

This is an [Elixir][1] application.

```
$ mix deps.get
$ cp config/config.dev.exs.example config/config.dev.exs
$ iex -S mix
```

The app will now be listening on `localhost:4000`.

## Deployment

### Releasing

Before anything, we need to generate a release tarball.

* Ensure you are compiling on the same OS as the production server (yes, distro matters).
* Ensure you have configured `config/config.prod.exs` with the right values.
* Copy `rel/config.exs.example` to `rel/config.exs` and fill in the `cookie`
  value with a random string.
* Run `MIX_ENV=prod mix release`

### Ansible!

Check out the `./deploy` directory in the repo, which contains a
fully-functioning Ansible playbook for deploying secretary to one or
more servers. This is what I use to deploy my instances.

### Or Manually

If you haven't yet tried Ansible and aren't willing to change your life, then
you can also deploy the app manually.

* Upload `rel/secretary/releases/$VERSION/secretary.tar.gz` to a server.
* On the server, extract the tarball and run `bin/secretary start` to start a
  forked background process.
* You'll want to configure some sort of reverse-proxy like NGINX to terminate
  TLS and bind to a "normal" port like 443.

### Extra: A systemd service

If manually starting the daemon feels wrong to you, you are correct! This is no
way to treat a production system. Rather, here's a nice succinct systemd unit
for you to place at `/etc/systemd/system/secretary.service`:

```ini
[Unit]
After=networking.target

[Service]
ExecStart=/usr/local/secretary/bin/secretary foreground
ExecStop=/usr/local/secretary/bin/secretary stop
User=secretary
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Of course, changing `/usr/local/secretary` to reflect the path where you
extracted the tarball.

## Github Setup

Once the app is running, invite your bot user to the repository with write
permissions so it has permissions to label things.

Then, under "Settings" -> "Webhooks" on your repository, add a new webhook.

* Configure the URL to be wherever you hosted Secretary.
* Set a long random string as the secret (and make sure it's configured in
  `config.prod.exs`).
* For the events, select "Let me select individual events" and check **only**
  `Pull Request`.

Save the webhook, and new PRs should be labelled (existing ones should get
labelled once interacted with).

## License

See [LICENSE](./LICENSE).
