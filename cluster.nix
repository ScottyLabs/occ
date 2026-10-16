{
  adminKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwjDM2gTgro+aN81I65BFexfLXq1u/8AJ3PmCTX5X/a i@anish.land"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABmf+NCxBMyuZukhxuE4fQIAJNf7WQI9ieKq2gUaXba git.cmu.dev from zenbook"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNCiqUwmemyjJGA7bK+8myy6urHhPrGnGMKJ59h8185 xboxbedrock@gmail.com"
  ];

  hosts = {
    mimosa = {
      system = "aarch64-linux";
      address = "128.2.96.10";
    };
  };
}
