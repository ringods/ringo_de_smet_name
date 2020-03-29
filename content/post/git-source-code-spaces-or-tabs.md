+++
date = "2013-02-08"
title = "Git, source code, spaces or tabs?"
slug = "git-source-code-spaces-or-tabs"
+++

In a previous article, I talked about [converting from TFS to Git](/2013/02/migrating-from-tfs-to-git/) 
and documented the normalization of the line endings in the converted Git repository. Another aspect of source 
code is whether spaces or tabs should be used.

Again, I'm not going to argument in favor of one or the other, but just document how you can get a consistent 
setup for your team. This setup however is something that can't be easily committed in the repository itself 
like it was done with the line ending configuration. The main reason are the scripts that need to be executed 
to make sure that any content is processed when checking out or into the repository.

<!--more-->

## Converting spaces to tabs

To get a good setup, use the [same git attributes](http://git-scm.com/book/ch7-2.html#Keyword-Expansion) 
to process any file. In my repository, the C# code was indented with 4 spaces while the XML files where 
indented with 2 spaces. If you want everything to be tabs, but you want to keep consistent indentation, 
you set up 2 filters in `.git/config`, one for each file type:

{{< gist id="c738ae3769155779099d" file="git-config.ini" >}}

Our filters are defined, now we only have to make them active by adding the following to `.git/info/attributes`:

{{< gist id="c738ae3769155779099d" file="git-attributes.ini" >}}

Similar to the line endings, git needs to reprocess all your files. This is done by clearing the working copy and 
getting a new set of working copy files:

{{< gist id="c738ae3769155779099d" file="reprocess.sh" >}}

This should transform all spaces to tabs in C# and XML files and commit the tabbed files to the git database.

## Platform dependency

The filter definitions use the Unix [unexpand](http://linux.about.com/library/cmd/blcmdl1_unexpand.htm) command. 
This setup is not portable to Windows, neither will it work on Mac OS X as the standard unexpand is not real 
GNU unexpand. This means that every developer needs to have a different setup based on the tools available. 
This is very cumbersome.

Another option is [EditorConfig](http://editorconfig.org). EditorConfig is a tool that can be plugged into a 
number of different editors and IDE's and takes over your source file formatting regarding indentation and line 
endings. The source file formatting definition can be committed to the source code repository. Although not 
all developers will probably use the same editor, with the EditorConfig plugin installed the team will nevertheless 
have consistent source code formatting.