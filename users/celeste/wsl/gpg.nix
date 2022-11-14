{ lib, config, pkgs, ... }: with lib; let exe = pkgs.fetchurl {
  url = "https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/download/v1.4.0/wsl2-ssh-pageant.exe";
  sha256 = "b3FFf4PTwY9ekGE7tMui5QGIW4EkCcTC+GwC1dxDez0=";
}; in
{
  # Disable the normal gpg-agent
  services.gpg-agent.enable = mkForce false;
  # Don't autostart it ever either
  programs.gpg.settings.no-autostart = true;
  # Fish config
  programs.fish.shellInit = let
    ss = pkgs.iproute + "/bin/ss";
    grep = pkgs.gnugrep + "/bin/grep";
    socat = pkgs.socat + "/bin/socat";
    windows_dest = "/mnt/c/nixos/wsl2-ssh-pageant.exe";
    homedir = config.programs.gpg.homedir;
  in ''
    set -x SSH_AUTH_SOCK "$HOME/.ssh/agent.sock"
    set -x GPG_AGENT_SOCK "${homedir}/S.gpg-agent"
    if not ${ss} -a | ${grep} -q "$SSH_AUTH_SOCK";
      rm -f "$SSH_AUTH_SOCK"
      rm -f "$GPG_AGENT_SOCK"
      mkdir -p "${homedir}"
      if not test -x "${windows_dest}"; # TODO: always do? check hash? it's fine for me personally, but technically someone could modify the exe out from under us
        install -Dm 755 -T "${exe}" "${windows_dest}"
      end
      setsid -f nohup ${socat} UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"${windows_dest}" >/dev/null 2>&1 &
      setsid -f nohup ${socat} UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"${windows_dest} -gpgConfigBasepath C\:/Users/Celeste/AppData/Local/gnupg -gpg S.gpg-agent" >/dev/null 2>&1 &
    end
  '';
}