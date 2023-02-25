{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    profiles.arkenfox = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        floccus
        private-relay
        ublock-origin
      ];
      isDefault = true;
      search.default = "DuckDuckGo";
    };
  };
}
