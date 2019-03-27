#/usr/bin/env bash
# bash completion for vdo command
# Achilles Gaikwad
# agaikwad@redhat.com



## These functions will be used throughout the bash script

## TODO : Right now what happens is the input is only parsed by taking the first
## Option that appears, change it to only display options with two -'s
## Example: --name instead of -n since it gives more information to user.
## Until then using a workaround of printing stuff via the variable
## DEFALT (intended spelling mistake.)


DEFALT='--help --all --name --confFile'

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
  case "${prev}" in
        -f|--confFile|--logfile)
          _filedir
         ;;
         -n|--name)
         _vdo_devdir
         ;;

        --all|-a|--verbose)
         return

   esac

}
_status()
{
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo status)'  -- "$cur" ) )

  case "${prev}" in
        -f|--confFile|--logfile)
          _filedir
         ;;
         -n|--name)
         _vdo_devdir
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
             -n|--name)
             _vdo_devdir
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
             -n|--name)
             _vdo_devdir
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
            -n|--name)
                 _vdo_devdir
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
            -n|--name)
                 _vdo_devdir
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
          -n|--name)
               _vdo_devdir
           ;;
          --verbose)
           return
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
          -n|--name)
               _vdo_devdir
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
          -n|--name)
               _vdo_devdir
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
        -n|--name)
             _vdo_devdir
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
       -n|--name)
            _vdo_devdir
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
        -n|--name)
             _vdo_devdir
         ;;
   esac
}


 _create()
 {

 #
  local cur prev words cword options
  _init_completion || return
  COMPREPLY=( $( compgen -W '$(_parse_vdo_options vdo create)' -- "$cur" ) )
  case "${prev}" in
      --force|--verbose)
         return
      ;;
# I probably shouldn't have added this.. note : remove this later.
      --indexMem)
        COMPREPLY=( $( compgen -W '0.25 0.5 0.75 {1..1024}' -- "$cur" ) )
        ;;

      --activate|--compression|--deduplication|--emulate512|--sparseIndex)
	       COMPREPLY=( $( compgen -W 'disabled enabled' -- "$cur" ) )
			;;
  	  --writePolicy)
         COMPREPLY=( $( compgen -W 'sync async auto' -- "$cur" ) )
			;;
		  --vdoLogLevel)
		     COMPREPLY=( $( compgen -W 'critical error warning notice info debug' -- "$cur" ) )
			;;
      --device|-n|--name)
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
COMPREPLY=( $( compgen -W '$( _parse_vdo_options vdo activate )' -- "$cur" ) )

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
