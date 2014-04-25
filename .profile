#. /usr/local/share/chruby/chruby.sh

git config --global --add alias.lol "log --graph --decorate --pretty=oneline --abbrev-commit --all"
git config --global --add alias.lol "log --graph --decorate --pretty=oneline --abbrev-commit --all"

complete -C /Users/pivotal/.local/lib/aws/bin/aws_completer aws

#chruby ruby-1.9.3-p448
export JAVA_HOME=`/usr/libexec/java_home -v 1.6`
export maj=cetas-dev-majestic
export w="$HOME/workspace"
export wda="$HOME/workspace/deployments-aws"
export wd="$HOME/workspace/dea_ng"
export wcc="$HOME/workspace/cloud_controller_ng"
export wcf="$HOME/workspace/cf-release"
export wb="$HOME/workspace/bosh"
export wp="$HOME/workspace/prod-aws"
export wt="$HOME/workspace/tools"
export th_ssh_config="$HOME/Dropbox/home/thansmann/.ssh/config"
export dht="$HOME/Dropbox/home/thansmann"
export PATH=$PATH:$dht/bin:/usr/local/go/bin:$HOME/go/bin:$EC2_HOME/bin
export jb=jb.run.pivotal.io
export staging=jb.staging.cf-app.com

alias gti='git'
alias ll='ls -alrt'
alias w="cd $HOME/workspace"
alias wda="cd $HOME/workspace/deployments-aws"
alias wd="cd $HOME/workspace/dea_ng"
alias wcc="cd $HOME/workspace/cloud_controller_ng"
alias wcf="cd $HOME/workspace/cf-release"
alias wb="cd $HOME/workspace/bosh"
alias wt="cd $HOME/workspace/tools"
alias wp="cd $HOME/workspace/prod-aws"
alias wy="cd $HOME/workspace/vcap-yeti"
alias vp='vim $HOME/Dropbox/home/thansmann/.profile'
alias dht='cd $HOME/Dropbox/home/thansmann'
alias d='cd $HOME/Dropbox'
alias sp='. $HOME/Dropbox/home/thansmann/.profile'
alias b='bundle '
alias bundel='bundle '
alias x='echo '
alias sg='git status'
alias e='egrep'
alias ll='ls -lart'
alias l.='ldot'
alias dir='ls -lart|grep ^d'
alias pa='. $te/aliases'
alias c='tput clear'
alias n='nslookup'
alias t='cd ~/tmp/; pwd'
alias ec='emacsclient'
alias r=$(type -p ruby)
alias rd=$(type -p rdebug)
alias XX='set -x'
alias xx='set +x'
alias rrh='echo rbenv rehash; rbenv rehash'
alias bed='bosh edit deployment'
alias bv='bosh vms'
alias btl='bosh task last'
alias btld='bosh task last --debug'
alias btr='bosh tasks recent 50'
alias btrn='bosh tasks recent 50 --no-filter'
alias gpp='git pull --rebase && git push'
alias gppom='git pull --rebase && git push origin master'
alias gst='git status'


function be() {
  if [ "$1" = "green" ]; then
    shift
    bundle exec rspec $*
  else
    bundle exec $*
  fi
}

[[ -d ~/workspace/tools ]] && . ~/workspace/tools/bosh_ssh
[[ -d ~/workspace/cf-tools ]] && . ~/workspace/cf-tools/bosh_ssh

function known_hosts_kill (){
    o
    cp -a $HOME/.ssh/known_hosts $o
    > $HOME/.ssh/known_hosts
    }

#  does a source on my profile
function sp {
if [[ ! -z "$ALT_HOME" ]] ; then
  . $ALT_HOME/.profile
  else
    . ~/.profile
fi
}

# vi my profile
function vp () {
if [[ ! -z "$ALT_HOME" ]] ; then
    vi $ALT_HOME/.profile $ALT_HOME/profile.d/*
  else
    vi ~/.profile ~/profile.d/*
fi
}

# save me from mistying less
function le () {
less $*
}

function les () {
less $*
}


biguns () { find $1 -mount -size +${2:-2000} -exec ls -ld {} \; ; }
Fsort () { sort -rn +4 -5 - ; }
Fsum () { awk '{ s+=$5 }
        END {print s, "bytes" }' ;}
sbiguns () { biguns $1 $2 | Fsort ; }

function ldot {
    ls -al $1|perl -n -e 'if ( /^-/ ) {split;if (@_[-1] =~ /^\..*$/) {print "@_[-1] \n";}}'
}

function db () {
  cd ~/Dropbox
  pwd
}

function dbh () {
  cd ~/Dropbox/home/thansmann
  pwd
}

function tssh () {
  ssh -F ${th_ssh_config} $*
}

function tscp () {
  scp -F ${th_ssh_config} $*
}

function vsc () {
  vim ${th_ssh_config}
}

function diary (){
  vim $dht/diary
}

function bosh_all () {
  parallel -j5 --keep "bosh -n --color {}" ::: status deployments stemcells releases
}

function bt () {
  bosh target $*
}

function btl () {
  bosh task last $*
}

function btr () {
  bosh tasks recent 15
}

function seed_etc_profile (){
  sudo ' echo "function sp () { source $dht/.profile ; }" >> /etc/profile'
}

function th_ssh_key () {
  chmod 400 /Users/pivotal/Dropbox/home/thansmann/.ssh/gerrit_id_rsa
  ssh-add /Users/pivotal/Dropbox/home/thansmann/.ssh/gerrit_id_rsa
}

alias tkey='th_ssh_key'

function gh () {
  echo git clone ssh://git@github.com/cloudfoundry/cf-release.git
}

function tabasco () {
  bosh_me bosh.tabasco.cf-app.com
  NATS_USER_PASS=$(ruby -ryaml -e 'y = YAML.load_file("#{ENV["HOME"]}/workspace/deployments-aws/tabasco/cf-aws-stub.yml"); puts "#{y["properties"]["nats"]["user"]}:#{y["properties"]["nats"]["password"]}"')
}

function a1 () {
  bosh_me bosh.a1.cf-app.com
  NATS_USER_PASS=$( ruby -ryaml -e 'y = YAML.load_file("#{ENV["HOME"]}/workspace/deployments-aws/a1/cf-shared-secrets.yml"); puts "#{y["properties"]["nats"]["user"]}:#{y["properties"]["nats"]["password"]}"' )
}

function nats-ads () {
  ( cd /Users/pivotal/workspace/tools/nats-inspect
    go get
    go install
    bosh_tunnel nats/0 &
    echo sleep a 12 sec to let the tunnel come up
    sleep 12
    ./nats-inspect -u="nat://${NATS_USER_PASS}@localhost:4222" dea-ads
  )
}

function prod () {
  ssh-add -D
  chmod 400 $HOME/workspace/prod-aws/keys/id_rsa_thansmann
  ssh-add -t 4900 $HOME/workspace/prod-aws/keys/id_rsa_thansmann
  ssh -A thansmann@jb.run.pivotal.io
}

function rprod () {
  ssh-add -D
  chmod 400 /Users/pivotal/workspace/prod-aws/config/id_rsa_jb
  ssh-add -t 4900 /Users/pivotal/workspace/prod-aws/config/id_rsa_jb
  ssh -A ubuntu@jb.go.cloudfoundry.com
}

function bosh_me () {
  bosh target $1
  BOSH_ENV=$(echo $1 | cut -f 2 -d '.' )
  bosh status
  bosh deployment $HOME/workspace/deployments-aws/$BOSH_ENV/cf-aws-stub.yml
}


function clear_4222 () {
  ps aux | grep ssh|grep 4222 | grep -v grep
  ps aux | grep ssh|grep 4222 | grep -v grep|awk '{print $2}'|xargs kill
  echo after
  ps aux | grep ssh|grep 4222 | grep -v grep

}


function cf_tools () {
(
w
git clone git@github.com:cloudfoundry/tools-cf-plugin.git

cd tools-cf-plugin
  cd tools-cf-plugin/
  ll
   gem build tools-cf-plugin.gemspec
    gem install tools-cf-plugin-*.gem
    )
}

function pass () {
  vim /Users/pivotal/workspace/prod-aws/passwords_and_accounts.md

}

function D () {
    date +%F
}

#
function check_ssh_keys() {
  ssh-add -D
  if [[ $(date +%H) -le 18 ]]
    then
      SEC_TO_6PM=$(echo "(19 - $(date +%H)) * 3600"  |bc)
    else
      SEC_TO_6PM=$(echo "2 * 3600"  |bc)
  fi
  # Mon Apr 23 17:37:04 2012 setup for vmware
    for i in $HOME/workspace/prod-aws/keys/id_rsa_thansmann $dht/.ssh/gerrit_id_rsa $HOME/workspace/prod-keys/id_rsa_thansmann ; do
      if [[ -f $i ]]
        then
          chmod 400 $i
          ssh-add -t $SEC_TO_6PM $i
        else
          echo "Could not find: $i"
      fi
  done
  unset i
  ssh-add -ls
}

function kc () {
    keychain
    . ~/.keychain/*-sh
    check_ssh_keys
}

function space2slash_s_+() {
 perl -pe 's{\s+}{\\s+}g; print "\n"'
}


bbb(){
  set -x
  cat /Users/pivotal/Dropbox/home/thansmann/home_dot_files/bosh_job_paste | pbcopy
  set +x
}

function job_env {
  cat /Users/pivotal/Dropbox/home/runtime/job_env_paste | pbcopy
  echo "now paste it into the shell on your bosh job"
}

function bosh_diff_loop(){
  this_deploy=$(bosh -n deployment)
  deployment_name=$(basename $this_deploy)
  local tmp_file=~/tmp/${deployment_name}_$(date +%F)
  mkdir -p ~/tmp
  cp -v $this_deploy $tmp_file
  while :
    do
      bosh -n diff $1
      vi  $this_deploy
      cp $tmp_file $this_deploy
      read -p "Again (ctrl-c otherwise): " noskdie_ignore
    done
}

function dang() {
  bosh -n deploy
}

function goshdarnit() {
  bosh -n upload release && dang
}

function goddammit() {
  bosh -n create release --force && goshdarnit
}

function gfd () {
 cd ~/workspace/cf-release
 bosh target
 bosh deployment
 read -p "Press any key to continue: " arlksxi_ignore
 goddammit
}

function dea_apps_prod (){
  check_ssh_keys
  cf tunnel-nats --director bosh.run.pivotal.io  --gateway thansmann@jb.run.pivotal.io --command dea-apps
}

function cf_tools (){
  if [[ ! -z "$*" ]] ; then
    check_ssh_keys
    cf tunnel-nats bosh.run.pivotal.io --gateway thansmann@jb.run.pivotal.io  $*
  else
    echo "$0 [dea-apps || dea-ads ]"
  fi
}

function gonarc() {
  cd ~/workspace/narc
  export GOPATH=$PWD
  cd src/github.com/vito/narc
}

function goto {
  cd ~/workspace/*$1* && \
    export GOPATH=$PWD && \
    export PATH=$GOPATH/bin:$PATH && \
    cd src/*/*/*${2:-$1}*
}

function virtualbox_start_my_stemcell (){
   epoch=$(date +%s)
   local stemcell_tgz=$1
   local stemcell_name=$(basename $stemcell_tgz | perl -pe 's/bosh-stemcell-// ;s/\.tgz//xmsi')
   local vm_name="${epoch}_${stemcell_name}"
   local tmp_dir=/tmp/${vm_name}
   mkdir ${tmp_dir} && cd ${tmp_dir} ;  tar xvf ${stemcell_tgz} image  ; tar xvf image
   VBoxManage import ${tmp_dir}/image.ovf  --vsys 0 --vmname ${vm_name}
   VBoxManage startvm ${vm_name}
}


function checkman {
  \curl https://raw.github.com/cppforlife/checkman/master/bin/install | bash -s
}

function bo {
  BUNDLE_GEMFILE=~/workspace/bosh/Gemfile bundle exec bosh $*
}

function fcd {
  cd $(dirname $1) 
}

function jb() {
  ssh -A thansmann@jb.run.pivotal.io

}

function staging() {
  ssh -L 25555:bosh.staging.cf-app.com:25555 -A thansmann@jb.staging.cf-app.com
}

function checklist_reset() {
  perl  -pe 's{\[x\]}{[ ]}g' $1
}

function prod_keys() {
  kc
  if [[ ! $(ssh-add -l | grep -q prod-keys) ]] ; then
    [[ -d ~/workspace/prod-keys ]] || git clone git@github.com:cloudfoundry/prod-keys.git  ~/workspace/prod-keys
    kc
  fi
}

function prod_aws() {
  kc
  if [[ ! $(ssh-add -l | grep -q prod-keys) ]] ; then
    [[ -d ~/workspace/prod-aws ]] || git clone git@github.com:cloudfoundry/prod-aws.git  ~/workspace/prod-aws
    ssh-add -
  fi
}

function whats_in_the_deploy() {
  kc
  cd ~/workspace/cf-release
  git fetch
  git checkout release-candidate
  ./update
  bundle install
  bundle exec git_release_notes html \
       -f origin/deployed-to-prod \
       -t origin/release-candidate \
       -u https://github.com/cloudfoundry/cf-release > ~/Desktop/whats-in-the-deploy.html
}

function ttmux() {
  tmux -f $dht/.tmux.conf
}

function myip() {
  wget -qO- http://ipecho.net/plain ; echo
}


function di() {
  bosh -t bosh.dijon.cf-app.com $*
}


function ta() {
  bosh -t bosh.tabasco.cf-app.com $*
}

function a1() {
  bosh -t bosh.a1.cf-app.com $*
}

function job_order() {
  # greps a bosh manifest for the list of jobs
  egrep '^jobs:|^  (name:)' $*

}

function describe-instances (){
  aws ec2 describe-instances --output text|  tr '	' ' ' | perl -pe 's/(RESERVATION)/\n$1/'
}

function ssl_decode_csr() {
  set -x
  set -f
  openssl req -in $1 -noout -text
  set +f
  set +x

}

alias bb='GEMFILE=~/workspace/bosh/Gemfile bundle exec bosh '

pushenv () {
    if [[ -d $dht ]] ; then
      pushd $dht
    else
      pushd ~
    fi
    scp -r .screenrc .profile env bin $1:;
    ssh $1 "chmod 755 .profile; ln -sf .profile .bash_profile";
    popd
}


function att_spiff(){
 bash -x /Users/pivotal/workspace/att_spiffable_template/att_spiff
}

function aws_ssh_fingerprint () {
  echo "This needs the private key to generate the digest aws uses"
  openssl rsa -in $1 -pubout -outform DER | openssl md5 -c
}

##############################
##########
# Wed Sep 26 13:47:25 2007
# got tired of making up tmp file names.
# get a tmpfile with your userid in it so there's no collisions
# theres a cleanvt fuction to so you can clear them easily.
# after you run this the '$f' var has the file you just edited for easy 
# recall - i wrote for this idiom:
# vi a tmp file, paste some junk, then "grep foo $f" 
function vt () {
      eval `next_file_named -f foo`
      vi $f
      echo $f
}

function vts () {
          eval `next_file_named -f foo`
          (echo '#!/bin/bash' ; echo ) >> $f
          chmod 755 $f
          vi + $f
          echo $f

}

function f () {
    eval `next_file_named -f foo`
      touch $f
      echo $f

}

function ef () {
      eval `current_file_named -f foo`
      echo $f

}


function o () {
        eval `next_file_named -f out`
        touch $o
        echo $o
}

function eo () {
      eval `current_file_named -f out`
      vi $o
      echo $o

}

function p () {
        eval `next_file_named -f put`
        touch $p
        echo $p


}

function ep () {
      eval `current_file_named -f put`
      echo $p

}


function q () {
        eval `next_file_named -f qoo`
        touch $q
        echo $q


}

function eq () {
      eval `current_file_named -f qoo`
      echo $q

}



function z () {
        eval `next_file_named -f zoo`
        touch $z
        echo $z


}


function ez () {
      eval `current_file_named -f zoo`
      echo $z

}



# causes a shell issue i can't figure out - commenting out Wed Mar  3 15:22:10 2010
 function all-e () {

  echo '
    f  - make a temp file and put it env var $f
    ej - existing jsh log file - exports j={current jsh file} to the env
    vj - vi existing jsh log file
    jc - get the last 25 jsh commands.
    it - instanciate temp file. use like: it; ifconfig > $f ; vi $f
    et - existing temp file - prints it and exports f={current foo tmp file} to the env
    vt - vi a NEW foo temp file -  exports f={current foo tmp file} to the env
    vts - make a temp file, add shbang line, mark 755, open in vi ready to insert.
    o - make a temp output file
    eo - make a temp output file and edit it.
'

 }


function migrate_basic_env() {
  if [[ -d ~/workspace/basic-env ]] ; then
    cd ~/workspace/basic-env && git stash && git pull --rebase && git stash pop
  else
    cd ~/workspace && git clone git@github.com:thansmann/basic-env.git
  fi
  if [[ -d ~/workspace/basic-env ]] ; then
    cp -a $dht/{.profile,.screenrc,.tmux.conf} $dht/home_dot_files/.gitconfig ~/workspace/basic-env
    mkdir -p ~/workspace/basic-env/bin
    cp -a $dht/bin/{ll,llp,lll,pcut,++,nl2.pl,print_between,tree_perms.pl,kibme,next_file_named,show_swapping_procs,llll} ~/workspace/basic-env/bin
    git status
  fi
}


function new_env() {
  echo "do setup for a new env"

}

