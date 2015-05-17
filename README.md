# bcd
### A better cd
---

This script is like `cd` with smart completion.

It does fuzzy(regular expression) search for the name you want in directories you specify. If there's a single match, it will go to that directory directly, if there are several directories, it will prompt to ask a number to choose.

![demo](./demo.png?raw=true)

---

### Installation
1. make sure erlang is installed

2. put the code below to your `~/.bashrc` or `~/.bash_profile` or `./zshrc`, etc. and change `$dirs` to directories you want to search from, `$scriptdir` to where main.erl is located

```shell
# or any name you like
bcd() {
  # change this to where main.erl is located
  scriptdir="$HOME/bcd"

  if [ $1 ]; then
    # change arguments from $PWD to the end to the directories you want to search from
    dir=`$scriptdir/main.erl $1 $PWD $HOME $HOME/projects $HOME/work`
    if [ -d "$dir" ]; then
      cd $dir;
    fi
  else
    cd $HOME;
  fi
}
```

---

### Usage

`bcd regex`
