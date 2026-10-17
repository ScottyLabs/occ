# Add an admin

## New admin

In the repo, add your SSH key and a post-quantum age key under `keys/admins/<name>/`, then open a pull request:

```sh
mkdir keys/admins/<name>
cp ~/.ssh/id_ed25519.pub keys/admins/<name>/ssh.pub
devenv shell -- age-keygen -pq -o ~/.config/sops/age/keys.txt
devenv shell -- age-keygen -y -o keys/admins/<name>/age.pub ~/.config/sops/age/keys.txt
```

On Linux, sops reads the private key from `~/.config/sops/age/keys.txt` by default; elsewhere, point `SOPS_AGE_KEY_FILE` at it.

## Existing admin

1. On the pull request's branch, re-encrypt each secrets file to the new recipient list in the devenv shell, and push:

   ```sh
   sops updatekeys secrets/<file>.yaml
   ```

1. Merge, then deploy every host so the SSH key reaches root's `authorized_keys`.

The new admin can then `ssh root@<host>.lan.cmu.edu` and `sops -d secrets/<file>.yaml`.
