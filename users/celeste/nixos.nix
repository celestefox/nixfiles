{
  config,
  pkgs,
  lib,
  ...
}: {
  users.users.celeste = {
    description = "Celeste Fox";
    uid = lib.mkDefault 1000;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDSQyfL3Q9Qn91KT+XkyoTImdm+fkxvgEp2Mg3WmuBKp5cxqxKdTk32Q9zYWc3Vrw50gHDruWpreFsPINIZTohdzA8GJERfiminw3tUysZUloT6nnCNvXVGjmyJkI4NJf0au77deoNqA0CjcPXNEsL5QwgMSCNn+Y6J9PtnsJkvrQfTougmaEZEqJHPLIUXjzVMreWn6zBN+6R+xvTQG2bLZmwxMocy9NW8Pb13eRdQFyl5R5O0MjLE6PgX3XxHsr4OHw+4XWArl35+Dkk00YtYlLhzs3cuVARpBg0neZtq1bDMOSQEqW1CJQrRaEYSrV8EUC+5y55ruuxXLWEPlP7Yedpo3HkrtAXEFc1N9qCTLfs1smxhPaJmMDLZGaWw3pXEkY6Rn1M4CSU6BBmrnkLIn4OaUX9Mf7Wr1imT1vhfxPg3PjfeJy++x22OTD2tgj3rPhQ3XHTGZC1bu5gAposvrwhIpp0vWDOlT+y2WBNP9WT4Yk65zk0TFJiIludCmuV2jSJ1LnHxXKgBIbLGqbkfEVusrL1E6SXHKXdrGPw+py84Hxt4sziJJdo2yvcMFgGjCnCprS+pghV35BF+itRwiPgLQ+kmrLa+8IVmHJF7IzUMB7jycxgWvO4QekslBOos0bnppHukhoLFMuPUwIrmd4tP+hZPqezM1Ikjw3AgJw== cardno:15_194_729"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmaV12dn2E+gUwNv+nyxy0p5OMkfyTm3T0yjxdc2HSxK6SiHyMj7iAlSDed02da8khtWMfa4dYAro7AyU1NJ5iAa9lsKJUzkZt2EywMmIZl33SNv6H3oMOI5RLTPPnH4yzRO4w3mmMDORztTS9p7EkF98WYNoty1wDB1p3hZ+lp63B2mFCCidwJaofG6pRLGcaPmZ6BKPzrkD4I+Jn6YeiFNeNvwuQAsdpZmThXQg53apRvu20+3diPDt7PIHzlje+RUkZFbyTCx887wIS+ywInvOb2nYnEl3fJhm3rzCwuBrexialJyS5hEL5MMTdeBcFLKnsuGoyOpjGeKQ8FYUdRDfEI+3s7GQ8qUn807p9SzqtuWkAVcdkMDBjAgyIV26PGA5UqRRx/93V77sdkSd36b99tOPR4w1auvfNsa0i/nKQhQ+HbT2V6K+x0hJZq3fta8ihX1R6ZcCS4uEnpWt9bGyyusa/tAibgtCJzEiJc3rAe6qCDGPfGK8PiaH7VKQHF/zz/vHlpMtds90gkN9z6B5SiMsMcYL3GN2oPKC4R7GiTvSx/E+OcjrXCKUakAXRXXOg3E2olxSoJXJmBWO7iJEurO62yiuiio4i831civo79EnUFoYupsA40k3pnpim9apBabuDMUAyZQK/SxiJ7dYMsAriih1/AOYZXE4Mtw== cardno:15 194 729"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDN4C+JvK2Dc9WdLKMdMFgEU1sYskJQvTEU62YVw1fy3yxRTGXsV7Xlbls0w0NoVZ+3rLaZHmEKzwQXRpATXnujf6e88aF8AVaMTRcH01r6Ev6Z3WNCWI5odJqxpbaCnVfZYCAuVtEZHaPcDF/xEHKr9DPRpEr1lD9XmDRTzxKC+06LpFdeqnmc6UPYbdGgiSfrrB+6BaFAuQUvCJNUI6nUrrGokMSh8f+umkN2QXoO6yb95iRWLCch42aN26b3URxULbnvoFUDLq2+Ug0jfteXJwDpxe1BviXZYVhbzfkXrddYwk2yIDgxCsq1jzEpdCgc+v/WT98Qa1E1yFU0x/4jp65U7ABLyeUuVg0hGEveiI9X6VwnPObInyP+TS3rzqo0TdqLm7H5aOD+g3zHUcjzDO5OHjQ3lPIuLbq2SupXStjRK+Vzw1yZM0jPUnp9zBLvdhR0qwbiHV9/+5vZT2x26jqjQ0K0qMlN8wCO1xRzpnHLGqtgFpTx3dx93RXuxQj15XNwxfC+zjsd6NT7YnhxUGvUZfOebK4i9tJ21djJmzJTEFegi2X5JdqABAgio0oVdYV7L8WgQPUp0iZW7kU9KbqzS4TpKNdgC31Vx0dJmYGeNfWNTgA97KSqXTRiNXzr7XDMwLn92kxfKrSwi1z3Kj0I9pNkXSlxSkMMGsGHNQ== glow@amaterasu"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMbxi8tiGccLEVyWgi/x5myCtEZthOmPcNxBjqnnZRra glow@amaterasu"
    ];
    shell = pkgs.fish;
    group = "users";
    extraGroups = ["wheel" "audio" "video" "systemd-journal" "plugdev" "vboxusers" "adbusers" "libvirtd" "docker" "wireshark"];
    #hashedPassword = "$6$GMQrixgscVvF$uRYgBqeoTXCml/koXj8SVM8V/UQuXrjZOQO3LslVtqkL1oFTzMLOQIW38t3eEOgZ8Wn98fxn1ybgpj2ifLKoa.";
    hashedPassword = "$6$WEqhv9jK3adTC2V2$5ZQHBDquIK8RZe94qTpjCiJNv.HuDbgteovJfFEl408ldKt.zDv0GzHwjh0q7NyxYYLPLp.e3EG1BxmP16cRi/";
    isNormalUser = true;
  };

  systemd.tmpfiles.rules = [
    "f /var/lib/systemd/linger/celeste"
  ];

  # impermanence
  programs.fuse.userAllowOther = true;
}
