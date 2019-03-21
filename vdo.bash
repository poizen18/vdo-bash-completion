#/usr/bin/env bash
# bash completion for vdo                                  -*- shell-script -*-
# Achilles Gaikwad
# agaikwad@redhat.com


## These functions will be used throughout the bash script


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

 COMPREPLY=( $( compgen -W '--writePolicy -n --name --all --confFile $( _parse_usage vdo changeWritePolicy )' -- "$cur" ) )
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

#
 local cur prev words cword options
 _init_completion || return
 COMPREPLY=( $( compgen -W '-n --name --all --confFile $( _parse_usage vdo activate --help )' -- "$cur" ) )
 case "${prev}" in
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

