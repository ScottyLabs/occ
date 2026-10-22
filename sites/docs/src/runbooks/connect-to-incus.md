# Connect to Incus

Run these on your own machine.

1. Install the `incus` client. With Nix, `nix-shell -p incus-lts.client` opens a shell with it.

1. Add the cluster as a remote. Include the port, since the client uses port 8443 when the URL has none:

   ```sh
   incus remote add occ https://incus.occ.build:443 --auth-type=oidc
   ```

1. The command prints a code after an empty `URL:` line. Open [Microsoft's device sign-in page](https://login.microsoft.com/device), enter the code, and sign in with your Andrew ID. The command finishes once you've signed in.

1. Check that you can reach the cluster:

   ```sh
   incus list occ:
   ```

You can also use the [web UI](https://incus.occ.build), where you sign in with your Andrew ID.
