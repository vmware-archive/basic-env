*Basic Environment*

This repos sets up a basic Linux enviornment to interact with a bosh director.

**Usage:**

```
# ***WARNING: This is meant for a new env and force overwrites ~/.profile***
cd && git clone git clone https://github.com/pivotal-cf-experimental/basic-env.git
. basic-env/.profile
new_env
exec $SHELL -l 
```

**What 'new_env' sets up:**

1. **Symlinks rc files into ~**
   ***WARNING: This is meant for a new env and force overwrites ~/.profile***
```
.profile ->   ~/basic-env/.profile
.screenrc ->  ~/basic-env/.screenrc
.tmux.conf -> ~/basic-env/.tmux.conf
```
1. **Adds a ~/bin dir and copies files in place**
1. **Installs some helpful tools:**
    - ruby bundler 
    - bosh_cli
    - Gnu Parallel - better xargs
    - jq - grep for json
    - ack - src code grepper

