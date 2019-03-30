# vdo-bashcomp
this repo holds the data for vdo's bash completion that I am writing

This repo will be helpful in finding how I went from nothing in the bash completion to having a bashcompltion source. The reason that I want it to be here, is so that people who want to learn a thing or two, can go with it.

I am a newbie and therefore you may find mistakes or things that I could have done better, I would appreciate any feedback, good or bad or even ugly. :)

# Update March 10, 2019

I am learning about Regular Expressions so that I can write a function which can then parse the options that `vdo <command> --help` would provide.

The sources that I am used to learn regular expressions are : 
[1] https://mywiki.wooledge.org/RegularExpression
[2] https://www.lynda.com/Regular-Expressions-tutorials/ 

Who knew string and pattern matching can be a pain in the ass (in the beginning). 
The problem isn't just matching, problem is with precision and thinking of test cases where it may give a f-word-ing false positive! 

Also, I learnt another thing, it is only difficult in the beginning. If you keep doing it it will keep on getting easy. :)

# INSTALLATION

You will need "bash-completions" command installed 
You can get it for RHEL/CENTOS/FEDORA by executing the following command: 


 `# yum -y install bash-completion`


Once you've bash completion in place, you now need the vdo.bash file in your completions directory.
So, first clone this repo!
 
 `# git clone https://github.com/poizen18/vdo-bashcomp.git`
 
 
 `# sudo install vdo.bash /usr/share/bash-completion/completions/`
 
 
 `# source  /usr/share/bash-completion/completions/vdo.bash`
 
 # Test it !! 
 
 ` # vdo <tab><tab> `
 
 
 # BUGS! 
 
 Of course there will be bugs! Lets kill them :D 
 Please send the bugs to upstream vdo mailing list.
 
 # WHAT NOW?
 If you can fix a bug, please do! I appreciate it.
 If you can make something better, please do with details on 
          1. what you're changing
          2. why you're changing it
          3. how does it benefit us
          
 The only reason that I want you to help me with the above questions is because I want to learn and grow. You know something that I don't and I wish to understand what is that change. I am in no way doubting your technical ability of the change, just a avid learner :) 
  
