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

DEFAULT="-n --name --all --confFile"

## These functions exist to serve the one true King.


 _create()
 {

 #
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '${DEFAULT} $( _parse_usage vdo create )' -- "$cur" ) )
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

 COMPREPLY=( $( compgen -W '--writePolicy --name --all $( _parse_usage vdo changeWritePolicy )' -- "$cur" ) )
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
 #COMPREPLY=( $( compgen -W '-n --name --all --confFile $( _parse_usage vdo activate )' -- "$cur" ) )

COMPREPLY=( $( compgen -W '--all --name $( _parse_usage vdo activate )' -- "$cur" ) )

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
