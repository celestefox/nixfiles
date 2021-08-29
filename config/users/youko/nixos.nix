{ config, pkgs, lib, ... }:

{
  users.users.youko = {
    uid = 1000;
    isNormalUser = true;
    # SETUP Add this
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDN4C+JvK2Dc9WdLKMdMFgEU1sYskJQvTEU62YVw1fy3yxRTGXsV7Xlbls0w0NoVZ+3rLaZHmEKzwQXRpATXnujf6e88aF8AVaMTRcH01r6Ev6Z3WNCWI5odJqxpbaCnVfZYCAuVtEZHaPcDF/xEHKr9DPRpEr1lD9XmDRTzxKC+06LpFdeqnmc6UPYbdGgiSfrrB+6BaFAuQUvCJNUI6nUrrGokMSh8f+umkN2QXoO6yb95iRWLCch42aN26b3URxULbnvoFUDLq2+Ug0jfteXJwDpxe1BviXZYVhbzfkXrddYwk2yIDgxCsq1jzEpdCgc+v/WT98Qa1E1yFU0x/4jp65U7ABLyeUuVg0hGEveiI9X6VwnPObInyP+TS3rzqo0TdqLm7H5aOD+g3zHUcjzDO5OHjQ3lPIuLbq2SupXStjRK+Vzw1yZM0jPUnp9zBLvdhR0qwbiHV9/+5vZT2x26jqjQ0K0qMlN8wCO1xRzpnHLGqtgFpTx3dx93RXuxQj15XNwxfC+zjsd6NT7YnhxUGvUZfOebK4i9tJ21djJmzJTEFegi2X5JdqABAgio0oVdYV7L8WgQPUp0iZW7kU9KbqzS4TpKNdgC31Vx0dJmYGeNfWNTgA97KSqXTRiNXzr7XDMwLn92kxfKrSwi1z3Kj0I9pNkXSlxSkMMGsGHNQ== glow@amaterasu"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMbxi8tiGccLEVyWgi/x5myCtEZthOmPcNxBjqnnZRra glow@amaterasu"
    ];
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "video" "systemd-journal" "plugdev" ];
    # SETUP Change this
    hashedPassword =
      "$6$GMQrixgscVvF$uRYgBqeoTXCml/koXj8SVM8V/UQuXrjZOQO3LslVtqkL1oFTzMLOQIW38t3eEOgZ8Wn98fxn1ybgpj2ifLKoa.";
    };

    systemd.tmpfiles.rules = [
      "f /var/lib/systemd/linger/youko"
    ];
}
