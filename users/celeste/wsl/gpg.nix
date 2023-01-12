{ lib, config, pkgs, ... }: with lib; let # TODO: refactor this into a module
  exe = pkgs.fetchurl {
    url = "https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/download/v1.4.0/wsl2-ssh-pageant.exe";
    sha256 = "b3FFf4PTwY9ekGE7tMui5QGIW4EkCcTC+GwC1dxDez0=";
  };
in
{
  # Disable the normal gpg-agent
  services.gpg-agent.enable = mkForce false;
  # Don't autostart it ever either
  programs.gpg.settings.no-autostart = true;
  # Fish config
  programs.fish.shellInit =
    let
      ss = pkgs.iproute + "/bin/ss";
      grep = pkgs.gnugrep + "/bin/grep";
      socat = pkgs.socat + "/bin/socat";
      windows_dest = "/mnt/c/nixos/wsl2-ssh-pageant.exe";
      homedir = config.programs.gpg.homedir;
    in
    ''
      set -x SSH_AUTH_SOCK "$HOME/.ssh/agent.sock"
      set -x GPG_AGENT_SOCK "/run/user/1000/gnupg/S.gpg-agent"
      set _gpg_extra_sock "/run/user/1000/gnupg/S.gpg-agent.extra"
      if not test -x "${windows_dest}"; or test (nix hash file --sri --type sha256 "${windows_dest}") != "sha256-b3FFf4PTwY9ekGE7tMui5QGIW4EkCcTC+GwC1dxDez0=";
        install -Dm 755 -T "${exe}" "${windows_dest}"
      end
      # SSH
      if not ${ss} -a | ${grep} -q "$SSH_AUTH_SOCK";
        rm -f "$SSH_AUTH_SOCK" >/dev/null 2>&1
        mkdir -p (dirname $SSH_AUTH_SOCK)
        setsid -f nohup ${socat} UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"${windows_dest}" >/dev/null 2>&1 &
      end
      # GPG
      if not ${ss} -a | ${grep} -q "$GPG_AGENT_SOCK";
        rm -f "$GPG_AGENT_SOCK" >/dev/null 2>&1
        #mkdir -p (dirname $GPG_AGENT_SOCK)
        gpgconf --create-socketdir >/dev/null 2>&1
        setsid -f nohup ${socat} UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"${windows_dest} -gpgConfigBasepath C\:/Users/Celeste/AppData/Local/gnupg -gpg S.gpg-agent" >/dev/null 2>&1 &
      end
      # GPG extra
      if not ${ss} -a | ${grep} -q "$_gpg_extra_sock";
        rm -f "$_gpg_extra_sock" >/dev/null 2>&1
        #mkdir -p (dirname $_gpg_extra_sock)
        gpgconf --create-socketdir >/dev/null 2>&1
        setsid -f nohup ${socat} UNIX-LISTEN:"$_gpg_extra_sock,fork" EXEC:"${windows_dest} -gpgConfigBasepath C\:/Users/Celeste/AppData/Local/gnupg -gpg S.gpg-agent.extra" >/dev/null 2>&1 &
      end
    '';
}
