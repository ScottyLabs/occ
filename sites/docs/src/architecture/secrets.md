# Secrets

Secrets are kept in `secrets/` and encrypted with sops ([ADR 7](../decisions/0007-manage-secrets-with-sops-nix.md)). Every file there is encrypted to each host's TPM-sealed age identity ([ADR 8](../decisions/0008-decrypt-secrets-with-a-tpm-sealed-identity.md)) and each admin's post-quantum age key ([ADR 9](../decisions/0009-use-post-quantum-age-keys-for-admins.md)), except `secrets/hosts/<host>.yaml`, which is encrypted only to that host and the admins.

Running `sops` in the devenv shell encrypts new files to these recipients, which the shell reads from `keys/hosts/<host>/age.pub` and `keys/admins/<name>/age.pub`.

When a host's configuration is activated, sops-nix decrypts the secrets it declares with the host's identity at `/var/lib/sops-nix/key.txt`.

This is configured in [`sops.nix`](https://git.cmu.dev/ScottyLabs/occ/src/branch/main/modules/global/sops.nix) and [`devenv.nix`](https://git.cmu.dev/ScottyLabs/occ/src/branch/main/devenv.nix), and each secret is declared in the module that uses it.
