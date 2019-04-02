#/usr/bin/env bash
# bash completion for vdo command
# Achilles Gaikwad
# agaikwad@redhat.com
# https://github.com/poizen18/vdo-bash-completion

# Adding this variable, so that in future if this needs to be modified
# Where the location of confFile would be manually provided, we
# Should be able to read from that file :)

# Why not have a function that does call something like :
# function is $1, the argument is $2 and then everything else lies in
# the same block.

CONF_FILE=/etc/vdoconf.yml

__parse_vdo_options()
{
  local option option2 i IFS=',/|';
  option=;
  local -a array;
  if [[ $1 =~ --[A-Za-z0-9]+ ]] ; then
    read -a array <<< "${BASH_REMATCH[0]}"
  fi
  for i in "${array[@]}";
  do
    case "$i" in
      ---*)
      break
      ;;
      --?*)
      option=$i;
      break
      ;;
      -?*)
      [[ -n $option ]] || option=$i
      ;;
      *)
      break
      ;;
    esac;
  done;
  [[ -n $option ]] || return;
  IFS='
  ';
  if [[ $option =~ (\[((no|dont)-?)\]). ]]; then
    option2=${option/"${BASH_REMATCH[1]}"/};
    option2=${option2%%[<{().[]*};
    printf '%s\n' "${option2/=*/=}";
    option=${option/"${BASH_REMATCH[1]}"/"${BASH_REMATCH[2]}"};
  fi;
  option=${option%%[<{().[]*};
  printf '%s\n' "${option/=*/=}"
}

_parse_vdo_options()
{
  eval local cmd=$( quote "$1" );
  local line;
  {
    case $cmd in
      -)
      cat
      ;;
      *)
      LC_ALL=C "$( dequote "$cmd" )" $2 --help 2>&1
      ;;
    esac
  }| while read -r line; do
    [[ $line == *([[:blank:]])-* ]] || continue;
    while [[ $line =~ \
((^|[^-])-[A-Za-z0-9?][[:space:]]+)\[?[A-Z0-9]+\]? ]]; do
      line=${line/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"};
    done;
    __parse_vdo_options "${line// or /, }";
  done
}

_vdo_devdir()
{
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W "$(lsblk -pnro name)" -- "$cur" ))
}

_vdo_names()
{
  local cur prev words cword options
  _init_completion || return
  if [ ! -f $CONF_FILE ]; then
    return
  fi
  names=()
  while IFS= read -r line
  do
    if [[ $line =~ \!VDOService ]]; then
      names+=( $(echo $line | cut -d: -f1) )
    fi
  done < $CONF_FILE
  COMPREPLY=( $( compgen -W  " ${names[*]}"  -- "$cur"))
}

_generic_function()
{
# Added activate , works fine
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo $1 )' -- "$cur" ) )
  case "${prev}" in
    --verbose|--all|-a)
    return
    ;;
    --vdoLogicalSize)
    COMPREPLY=( $( compgen -W 'B K M G T P E' -- "$cur" ) )
    ;;
    -f|--confFile|--logfile)
    _filedir
    ;;
    -n|--name)
        if [[ "$1" == "create" ]]
        then
          return
        else
          _vdo_names
        fi
    ;;
    --writePolicy)
    COMPREPLY=( $( compgen -W 'sync async auto' -- "$cur" ) )
    ;;
    --force|--verbose)
    return
    ;;
    --activate|--compression|--deduplication|--emulate512|--sparseIndex)
    COMPREPLY=( $( compgen -W 'disabled enabled' -- "$cur" ) )
    ;;
    --writePolicy)
    COMPREPLY=( $( compgen -W 'sync async auto' -- "$cur" ) )
    ;;
    --vdoLogLevel)
    COMPREPLY=( $( compgen -W \
'critical error warning notice info debug' -- "$cur" ) )
    ;;
    --device)
      _vdo_devdir
      ;;
    --blockMapCacheSize|--maxDiscardSize|--vdoLogicalSize|--vdoSlabSize )
    COMPREPLY=( $( compgen -W 'B K M G T P E' -- "$cur" ) )
    ;;
    --blockMapCacheSize|--maxDiscardSize )
    COMPREPLY=( $( compgen -W 'B K M G T P E' -- "$cur" ) )
    ;;

  esac
  return
}

_vdo()
{
  local cur prev words cword
  _init_completion || return

  if [[ $cword -eq 1 ]]; then
    COMPREPLY=( $( compgen -W '
    activate changeWritePolicy create deactivate disableCompression
    disableDeduplication enableCompression enableDeduplication growLogical
    growPhysical list modify printConfigFile remove start status 
	stop' -- "$cur" ) )
  else
    case "${words[1]}" in
      activate|changeWritePolicy|create|deactivate|disableCompression|\
      disableDeduplication|enableCompression|enableDeduplication|\
      growLogical|growPhysical|list|modify|printConfigFile|remove|\
      start|status|stop)
	   _generic_function ${words[1]}
      ;;
    esac
  fi
} &&
complete -F _vdo vdo
