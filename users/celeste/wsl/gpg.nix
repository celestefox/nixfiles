{ lib, config, pkgs, ... }: with lib; let exe = pkgs.fetchurl {
  url = "https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/download/v1.4.0/wsl2-ssh-pageant.exe";
  sha256 = "b3FFf4PTwY9ekGE7tMui5QGIW4EkCcTC+GwC1dxDez0=";
}; in
{
  # Disable the normal gpg-agent
  services.gpg-agent.enable = mkForce false;
  # Fish config
  programs.fish.shellInit = let
    ss = pkgs.iproute + "/bin/ss";
    grep = pkgs.gnugrep + "/bin/grep";
    socat = pkgs.socat + "/bin/socat";
    windows_dest = "/mnt/c/nixos/wsl2-ssh-pageant.exe";
  in ''
    set -x SSH_AUTH_SOCK "$HOME/.ssh/agent.sock"
    set -x GPG_AGENT_SOCK "/run/user/1000/gnupg/S.gpg-agent"
    if not ${ss} -a | ${grep} -q "$SSH_AUTH_SOCK";
      rm -f "$SSH_AUTH_SOCK"
      rm -f "$GPG_AGENT_SOCK"
      mkdir -p /run/user/1000/gnupg
      if not test -x "${windows_dest}";
        install -Dm 755 -T "${exe}" "${windows_dest}"
      end
      setsid -f nohup ${socat} UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"${windows_dest}" >/dev/null 2>&1 &
      setsid -f nohup ${socat} UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"${windows_dest} -gpgConfigBasepath C\:/Users/Celeste/AppData/Local/gnupg -gpg S.gpg-agent" >/dev/null 2>&1 &
    end
  '';
}