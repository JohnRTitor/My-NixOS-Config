{...}:
# A smarter cd command which learns your habits as you go
{
  programs.zoxide.enable = true;
  programs.zoxide.options = [
    "--cmd cd" # Make cd an alias of zoxide
  ];
}
