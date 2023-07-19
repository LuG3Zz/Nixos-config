{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    autocd = true; # cdなしでファイルパスだけで移動
    enableCompletion = true; # 自動補完
    enableAutosuggestions = true; # 入力サジェスト
    syntaxHighlighting.enable = true; # シンタックスハイライト
    shellAliases = {
      cat = "bat";
      grep = "rg";
      ls = "exa --icons --classify";
      la = "exa --all --icons --classify";
      ll = "exa --long --all --git --icons";
      tree = "exa --icons --classify --tree";
      ps = "${pkgs.procs}/bin/procs";
    };
     initExtra = ''
     export EDITOR="nvim"

     export OPENAI_API_KEY="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"

    '';
  };
}
