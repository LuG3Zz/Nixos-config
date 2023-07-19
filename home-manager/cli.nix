
{ config, pkgs, ... }: {

  # 之前的 systemPackages 是系统范围包，这里就是用户范围包
  home.packages = with pkgs; [
    p7zip
    unzip
    unrar
    trash-cli
    proxychains-ng
    bat
    bottom
    exa
    httpie
    pingu
    ripgrep
    zoxide
  ];

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };


  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  # 启用 starship，这是一个漂亮的 shell 提示符
  programs.starship = {
    enable = true;
    # 自定义配置
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

#  home.file = {
#    ".proxychains/proxychains.conf".source = ../dotfiles/proxychains.conf;
#  };
#
#  xdg.configFile = {
#    "mpv".source = ../dotfiles/mpv;
#    "alacritty/alacritty.yml".source = ../dotfiles/alacritty.yml;
#  };
}
