{
  config,
  pkgs,
  ...
}: {
  networking = {
    hostName = "gram";
    firewall.enable = false;
    #networkmanager.enable = true;
    wireless = {
      enable = true;
      userControlled.enable = true;

      #networking.firewall.allowedUDPPorts = [...];
      #networking.firewall.allowedTCPPorts = [...];

      #networking.proxy.default = "http://user:password@proxy:port/";
      #networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      #Define your networks here
      #Syntax :
      networks."ChoiFL-5G" = {
        psk = "guguplex";
        hidden = true;
      };
      #      networks.SurClub_Guest = {};
    };
  };
}
