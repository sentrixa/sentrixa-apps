# sentrixa-apps

Nix packaging for Sentrixa's first-party Linux apps, kept separate from the
private `sentrixa-os` repo so any machine — not just ours — can install them
per-user with plain Nix:

```sh
nix profile install github:sentrixa/sentrixa-apps#stratavault
```

Each app here is built from its already-public release artifact (the same
`.deb` published at `repo.sentrixa.co.uk`), just wrapped to run under Nix.
This repo deliberately contains no Sentrixa OS source, infrastructure, or
internal tooling — packaging recipes only.
