#/usr/bin/env bash
# bash completion for vdo                                  -*- shell-script -*-
# Achilles Gaikwad
# agaikwad@redhat.com

# can I in someway do somthing like this : 
# vdo activate --help | sed '1,/optional/d' | grep -v "                        " | awk {'print $1" "$2'}
# What I am looking for is automation, rather than writing all the commands this way. 
# Since I am the owner, I can do what I want :) Believe.
# maybe talk with sorenson on what you can do?

# this is awesome progress, got to know about the util _parse_usage which can help
# me get the data that I need for a command, instead of doing the donkey work!! 

_activate()
{
 local cur prev words cword options
 _init_completion || return

# options = "-h|--help|-a|--all|--verbose|-n|--name|-f|--confFile|--logfile"
# COMPREPLY=( $( compgen -W '${options}' -- "$cur" ) )

COMPREPLY=( $( compgen -W '$( _parse_usage vdo activate --help )' -- "$cur" ) )

 #if [[ $cword -eq 1 ]]; then

 case $prev in
#	 -h|--help|-a|--all|--verbose)
#		             COMPREPLY=( $( compgen -W '-h|--help|-a|--all|--verbose' -- "$cur" ) )
#
# I don't think this is needed because you'll only want to go ahead with other stuff for below files
# ;;

	 -n|--name|-f|--confFile|--logfile)
				_${words[1]}
				;;

 esac
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

