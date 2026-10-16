# Set up a host's TPM identity

1. On the host, as root, generate the identity:

    ```sh
    install -d -m 700 /var/lib/sops-nix
    nix shell nixpkgs#age-plugin-tpm -c age-plugin-tpm --generate -o /var/lib/sops-nix/key.txt
    ```

2. From the repo, save the host's recipient:

    ```sh
    mkdir -p keys/hosts/<host>
    ssh root@<host>.lan.cmu.edu 'nix shell nixpkgs#age-plugin-tpm -c age-plugin-tpm -y /var/lib/sops-nix/key.txt' > keys/hosts/<host>/age.pub
    ```

3. In the devshell, re-encrypt each existing secrets file to the new recipient list:

    ```sh
    sops updatekeys secrets/<file>.yaml
    ```

4. Commit and deploy the host.
