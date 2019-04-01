#/usr/bin/env bash
# bash completion for vdo command
# Achilles Gaikwad
# agaikwad@redhat.com
# https://github.com/poizen18/vdo-bash-completion

__parse_vdo_options ()
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
    while [[ $line =~ ((^|[^-])-[A-Za-z0-9?][[:space:]]+)\[?[A-Z0-9]+\]? ]]; do
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

_stop()
{
  local cur prev words cword options
  _init_completion || return

  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo stop  )'  -- "$cur" ) )
  case "${prev}" in
    -f|--confFile|--logfile)
    _filedir
    ;;
    --all|-a|--verbose)
    return
  esac
}

_status()
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo status)'  -- "$cur" ) )
  {

  case "${prev}" in
    -f|--confFile|--logfile)
    _filedir
    ;;
    --all|-a|--verbose)
    return
  esac
}

_start()
{
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo start)'  -- "$cur" ) )

  case "${prev}" in
    -f|--confFile|--logfile)
    _filedir
    ;;
    --all|-a|--verbose)
    return
  esac

}
_remove()
{
  local cur prev words cword options
  _init_completion || return

  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo remove)'  -- "$cur" ) )
  case "${prev}" in
    -f|--confFile|--logfile)
    _filedir
    ;;
    --all|-a|--verbose)
    return
  esac
}
_printConfigFile()
{
  local cur prev words cword options
  _init_completion || return

  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo printConfigFile)'  -- "$cur" ) )
  case "${prev}" in
    -f|--confFile|--logfile)
    _filedir
    ;;
    --verbose)
    return
  esac
}

_modify()
{
  local cur prev words cword options
  _init_completion || return

  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo modify)'  -- "$cur" ) )
  ## This looks like create, get back to this later.
  case "${prev}" in
    --force|--verbose)
    return
    ;;
    # I probably shouldn't have added this.. note : remove this later.
    --indexMem)
    COMPREPLY=( $( compgen -W '0.25 0.5 0.75 {1..1024}' -- "$cur" ) )
    ;;
    --device)
    _vdo_devdir
    ;;
    --blockMapCacheSize|--maxDiscardSize )
    COMPREPLY=( $( compgen -W 'B K M G T P E' -- "$cur" ) )
    ;;
    -f|--confFile|--logfile)
    _filedir
    ;;
  esac
}

_list()
{
  local cur prev words cword options
  _init_completion || return

  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo list)'  -- "$cur" ) )
  case "${prev}" in
    -f|--confFile|--logfile)
    _filedir
    ;;
    --verbose|--all|-a)
    return
  esac
}

_growPhysical()
{
  local cur prev words cword options
  _init_completion || return

  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo growPhysical )'  -- "$cur" ) )
  case "${prev}" in
    -f|--confFile|--logfile)
    _filedir
    ;;
    --verbose)
    return
  esac
}

_growLogical()
{
  local cur prev words cword options
  _init_completion || return

  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo growLogical)'  -- "$cur" ) )
  case "${prev}" in
    -f|--confFile|--logfile)
    _filedir
    ;;
    --vdoLogicalSize)
    COMPREPLY=( $( compgen -W 'B K M G T P E' -- "$cur" ) )
    ;;
  esac
}

_enableDeduplication()
{
  local cur prev words cword options
  _init_completion || return

  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo enableDeduplication )'  -- "$cur" ) )
  case "${prev}" in
    -f|--confFile|--logfile)
    _filedir
    ;;
    --verbose)
    return
  esac
}

_enableCompression()
{
  local cur prev words cword options
  _init_completion || return

  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo enableCompression)'  -- "$cur" ) )
  case "${prev}" in
    -f|--confFile|--logfile)
    _filedir
    ;;
    --verbose)
    return
  esac
}

_disableDeduplication()
{
  local cur prev words cword options
  _init_completion || return

  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo disableDeduplication)'  -- "$cur" ) )
  case "${prev}" in
    -f|--confFile|--logfile)
    _filedir
    ;;
    --verbose)
    return
  esac
}

_disableCompression()
{
  local cur prev words cword options
  _init_completion || return

  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo disableCompression )'  -- "$cur" ) )
  case "${prev}" in
    -f|--confFile|--logfile)
    _filedir
    ;;
  esac
}

_deactivate()
{
  local cur prev words cword options
  _init_completion || return

  COMPREPLY=( $( compgen -W ' $DEFALT $( _parse_vdo_options vdo deactivate )'  -- "$cur" ) )
  case "${prev}" in
    -f|--confFile|--logfile)
    _filedir
    ;;
  esac
}

_create()
{
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '$(_parse_vdo_options vdo create)' -- "$cur" ) )
  case "${prev}" in
    --force|--verbose)
    return
    ;;
    # I probably shouldn't have added this.. note : remove this later.
    #--indexMem)
    #COMPREPLY=( $( compgen -W '0.25 0.5 0.75 {1..1024}' -- "$cur" ) )
    #;;
    --activate|--compression|--deduplication|--emulate512|--sparseIndex)
    COMPREPLY=( $( compgen -W 'disabled enabled' -- "$cur" ) )
    ;;
    --writePolicy)
    COMPREPLY=( $( compgen -W 'sync async auto' -- "$cur" ) )
    ;;
    --vdoLogLevel)
    COMPREPLY=( $( compgen -W 'critical error warning notice info debug' -- "$cur" ) )
    ;;
    --device)
    _vdo_devdir
    ;;
    --blockMapCacheSize|--maxDiscardSize|--vdoLogicalSize|--vdoSlabSize )
    COMPREPLY=( $( compgen -W 'B K M G T P E' -- "$cur" ) )
    ;;
    -f|--confFile|--logfile)
    _filedir
    ;;
  esac
  return
}

_changeWritePolicy()
{
  local cur prev words cword options
  _init_completion || return

  COMPREPLY=( $( compgen -W ' $( _parse_vdo_options vdo changeWritePolicy )' -- "$cur" ) )
  case "${prev}" in
    --writePolicy)
    COMPREPLY=( $( compgen -W 'sync async auto' -- "$cur" ) )
    ;;
    -f|--confFile|--logfile)
    _filedir
    ;;
  esac
  return
}

_activate()
{
  local cur prev words cword options
  _init_completion || return

  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo activate )' -- "$cur" ) )
  case "${prev}" in
    --verbose|--all|-a|-n|--name)
    return
    ;;
    -f|--confFile|--logfile)
    _filedir
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
    growPhysical list modify printConfigFile remove start status stop' -- "$cur" ) )
  else
    case "${words[1]}" in
      activate|changeWritePolicy|create|deactivate|disableCompression|\
      disableDeduplication|enableCompression|enableDeduplication|growLogical|\
      growPhysical|list|modify|printConfigFile|remove|start|status|stop)
      _${words[1]}
      ;;
    esac
  fi
} &&
complete -F _vdo vdo
