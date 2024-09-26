{ config, pkgs, ... }:
{
	home.username = "dchoi";
	home.homeDirectory = "/home/dchoi";

	home.packages = with pkgs; [
		zip
		ripgrep
	];
	
	programs.home-manager.enable = true;
}
