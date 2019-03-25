#/usr/bin/env bash
# bash completion for vdo                                  -*- shell-script -*-
# Achilles Gaikwad
# agaikwad@redhat.com


## These functions will be used throughout the bash script

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
        __parse_options "${line// or /, }";
    done
}


# TODO: Change this directory to where vdo's volumes might exist once NOT activated.

_vdo_devdir()
{
    cur=${cur:-/dev/}
    _filedir
}

_stop()
{
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo stop  )'  -- "$cur" ) )
}
_status()
{
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo status)'  -- "$cur" ) )
}
_start()
{
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo start)'  -- "$cur" ) )
}
_remove()
{
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo remove)'  -- "$cur" ) )
}
_printConfigFile()
{
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo printConfigFile)'  -- "$cur" ) )
}
_modify()
{
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo modify)'  -- "$cur" ) )
}
_list()
{
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo list)'  -- "$cur" ) )
}
_growPhysical()
{
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo growPhysical )'  -- "$cur" ) )
}


_growLogical()
{
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo growLogical)'  -- "$cur" ) )
}
_enableDeduplication()
{
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo enableDeduplication )'  -- "$cur" ) )
}



_enableCompression()
{
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo enableCompression)'  -- "$cur" ) )
}


_disableDeduplication()
{
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo disableDeduplication)'  -- "$cur" ) )
}

_disableCompression()
{
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo disableCompression )'  -- "$cur" ) )
}



_deactivate()
{
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo deactivate )'  -- "$cur" ) )
}


 _create()
 {

 #
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo create )' -- "$cur" ) )
  case "${prev}" in
          --activate|--compression|--deduplication|--emulate512|--sparseIndex)
	       COMPREPLY=( $( compgen -W 'disabled enabled' -- "$cur" ) )
			;;
  		  --writePolicy)
           COMPREPLY=( $( compgen -W 'sync async auto' -- "$cur" ) )
			;;
		  --vdoLogLevel)
		   COMPREPLY=( $( compgen -W 'critical error warning notice info debug' -- "$cur" ) )
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
         -n|--name)
             _vdo_devdir
             ;;
 # Since we're going to look for a log file, why not mention the direct path here instead?
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
COMPREPLY=( $( compgen -W '--all --name $( _parse_vdo_options vdo activate )' -- "$cur" ) )

 case "${prev}" in
   --all|-a)
        return
        ;;
		-n|--name)
			_vdo_devdir
			;;
# Since we're going to look for a log file, why not mention the direct path here instead?
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
	activate             changeWritePolicy    create               deactivate           disableCompression   disableDeduplication enableCompression    enableDeduplication growLogical          growPhysical         list                 modify               printConfigFile      remove               start status stop' -- "$cur" ) )
    else
        case "${words[1]}" in
	            activate|changeWritePolicy|create|deactivate|disableCompression|disableDeduplication|\
		    enableCompression|enableDeduplication|growLogical|growPhysical|list|modify|\
		    printConfigFile|remove|start|status|stop)
        					        _${words[1]}
                ;;
        esac
    fi
} &&
complete -F _vdo vdo
