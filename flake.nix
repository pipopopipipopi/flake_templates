{
  description = "ワイのテンプレート達。";
  
  outputs = { self }: {
    templates = import ./template.nix;
  };
}
