let
  celeste = "age1yubikey1q2ldx7axezdnd38ela7u62wvyq36mayqqs4dvhfy57jlldyl68jkws4k6jp";
  users = [celeste];

  amaterasu = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGBYK342QNVbVNTNBuWv5F3HfQrYu0B/3ie59CSN/aaT";
  star = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN2immKEBrjPr0V6K1WdcIcCRN9Aw2PtxWXjSfC4M63e";
  hosts = [amaterasu star];

  all = users ++ hosts;
in {
  "gandi_key.age".publicKeys = all;
  "cf_lego.age".publicKeys = all;
  "keycloak_db_pw.age".publicKeys = users ++ [star];
  "iperf_auth.age".publicKeys = all;
  "star_wgnet_privkey.age".publicKeys = all;
  "vaultwarden-env.age".publicKeys = all;
  "smtp.age".publicKeys = all;
  "email_catfg.age".publicKeys = all;
}
