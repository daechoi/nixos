{pkgs, ...}: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.editor = false;
      timeout = 3;
    };
    kernelParams = ["quiet" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3"];
    consoleLogLevel = 0;
    initrd.verbose = false;
    initrd.systemd.enable = true;
  };
  systemd.watchdog.rebootTime = "0";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "ter-v32n";
    keyMap = "us";
    packages = with pkgs; [terminus_font];
  };
}
