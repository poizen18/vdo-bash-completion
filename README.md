# vdo-bashcomp

This repo holds the data for vdo's bash completion that I have written.

This repo will be helpful in finding how I went from nothing in the bash completion to having a bashcompltion source. The reason that I want it to be here, is so that people who want to learn a thing or two, can go with it. You can check the commit history on how I began writing the vdo's bash completion and how I finished it... 
Just a note if you're actually going to do that, there are a _lot_ of commits that are literally useless. Me trying things out, trying to make changes. They're there for no reason.

I am a newbie and therefore you may find mistakes or things that I could have done better, I would appreciate any feedback, good or bad or even ugly. :)
If you feel that I can write a function better, please let me know! I'd love it. 

The Journey : 
 < drum roll pls > 
# Beginning 
	Read this in David Attenborough's voice: 
	Life of this bash completion script began as he was writing some internal documentation for his team... 
	He found that it was very painful to actually type all the commands. Why is the savior <tab><tab> not helping him?

# Update March 10, 2019

I am learning about Regular Expressions so that I can write a function which can then parse the options that `vdo <command> --help` would provide.

The sources that I am used to learn regular expressions are : 

[1] https://mywiki.wooledge.org/RegularExpression


[2] https://www.lynda.com/Regular-Expressions-tutorials/ 


I learnt that earlier, editors used to have pattern matching in the format "g/REGULAR-EXPRESSION/p"
the suffix p indicates that the expression found should be printed. This is now a standalone program known to humans as *grep*

Who knew string and pattern matching can be a pain in the ass (in the beginning). 
The problem isn't just matching, problem is with precision and thinking of test cases where it may give a f-word-ing false positive! 

Also, I learnt another thing, it is only difficult in the beginning. If you keep doing it it will keep on getting easy. :)

# INSTALLATION

You will need "bash-completions" command installed
You can get it for RHEL/CENTOS/FEDORA by executing the following command: 


 `# yum -y install bash-completion`
 

start a new shell 
 

 `# bash`


Once you've bash completion in place, you now need the vdo.bash file in your completions directory.
So, first clone this repo!
 
 
 `$ cd /tmp/ ; git clone https://github.com/poizen18/vdo-bashcomp.git`
 

 `$ cd vdo-bash-completion`
 
 
 `$ sudo install vdo.bash /usr/share/bash-completion/completions/`
 

 `# source  /usr/share/bash-completion/completions/vdo.bash`
 
 
 # Test it !!
 
 `# vdo <tab><tab> `
 
 
 # BUGS ! 
 
 Of course there will be bugs! Lets kill them :D 
 Please send the bugs to upstream vdo mailing list. (hopefully by then I should have sent this to upstream)
 
 # WHAT NOW?
 If you can fix a bug, please do! I appreciate it.
 If you can make something better, please do with details on 


          1. what you're changing

          2. why you're changing it

          3. how does it benefit us
         
The only reason that I want you to help me with the above questions is because I want to learn and grow. You know something that I don't and I wish to understand what is that change. I am in no way doubting your technical ability of the change, just a avid learner :) 
  
