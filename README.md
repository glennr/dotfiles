# dotfiles for @glennr

Using `yadm` to manage my dotfiles. 

To install yadm, and these dotfiles:

```
sudo apt install yadm
yadm clone -f https://github.com/glennr/dotfiles.git
yadm restore --staged $HOME
yadm checkout -- $HOME
yadm bootstrap
```
