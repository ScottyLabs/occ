# Set up a host's TPM identity

1. On the host, as root, generate the identity and print its recipient:

    ```sh
    install -d -m 700 /var/lib/sops-nix
    nix shell nixpkgs#age-plugin-tpm -c sh -c '
      age-plugin-tpm --generate -o /var/lib/sops-nix/key.txt
      age-plugin-tpm -y /var/lib/sops-nix/key.txt
    '
    ```

2. Add the recipient to `keys` in `.sops.yaml` and to every creation rule the host should be able to read.

3. In the devshell, re-encrypt each existing secrets file to the new recipient list:

    ```sh
    sops updatekeys secrets/<file>.yaml
    ```

4. Deploy the host.
