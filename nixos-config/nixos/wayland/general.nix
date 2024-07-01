{config, ...}: {
  environment.extraInit = ''
    #Turn off gui for ssh auth
    unset -v SSH_ASKPASS
  '';
  users.users.dchoi.extraGroups = ["video"];
  programs.light.enable = true;
}
