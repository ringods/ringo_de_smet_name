+++
date = "2013-02-21T21:21:37+02:00"
title = "Migrating from TFS to Git with converted metadata"
slug = "migrating-from-tfs-to-git"
+++

If you are tasked with migrating a Team Foundation Server (TFS) code repository to Git and search the net, you will 
quickly find a number of tools:

* [`git-tfs`](https://github.com/git-tfs/git-tfs)
* [`TFS2GIT`](https://github.com/WilbertOnGithub/TFS2GIT)
* [`Git-TF`](http://gittf.codeplex.com)

The latter two solutions were tried in converting from the TFS repository to a Git repository.

<!--more-->

TFS2Git has the drawback that it is a shell wrapper around the tfs and git command line commands. It just replays 
the history but all git commits are timestamped with the execution time of the conversion, not the initial timestamp 
from the TFS repository. This was not favorable.

Git-TF is created by Microsoft to provide access to a TFS repository from non-Microsoft platforms like Linux and 
Mac OS X. It is a two-way bridge between a local Git checkout and a TFS server, meaning that you can work on the 
client with your Git toolchain, but pull and push to the central TFS server. As such, it works flawlessly with 
your TFS server. In a normal developer setup, you only pull the latest changes from TFS, continue working in your 
local git clone, and push your changes back as TFS changesets. However, performing a deep clone, even from a single 
branch with a bit of history, takes quite some time. Do you consider 26 hours acceptable for a history of around 
2500 commits?

Besides the conversion, a bit of git post-processing was done on the converted repository before it was pushed to 
the new git server. Let's get started!

## Converting from TFS to Git

To convert MyComponent with full history, without tagging the git revisions with the TFS commit info, run:

{{< gist id="168c2cf7726a536deb9c" file="convert.sh" >>}

In the above example, only the Development branch was converted. The team already used a minimal 
[Git Flow](http://nvie.com/posts/a-successful-git-branching-model/) like branch structure and the most granular 
commit info was on this branch. Given the conversion time mentioned above, converting all branches was not on option.

The intention is to execute a one-time conversion to Git and continue to work in Git. As such, we can remove the 
remote ref to the TFS server:

{{< gist id="168c2cf7726a536deb9c" file="remove-branch.sh" >}}

## Cleaning up the commit author information

After conversion, the author in every git revision refers to the respective Active Directory user account. 
As git users, we are used to the regular email style information. So let's rewrite some git history. 
Most people seem to know the 
[Github script for changing author info](https://help.github.com/articles/changing-author-info), 
but the script below can change multiple authors at once in a single rewrite run:

{{< gist id="168c2cf7726a536deb9c" file="cleanup.sh" >}}

After running this conversion script in your git repo, it is a good idea to perform some cleanup:

{{< gist id="168c2cf7726a536deb9c" file="prune.sh" >}}

Your git repository should shrink considerably.

## Line endings...

The never ending debate of line endings. I'm not going to enter this debate of which is better. A good article on 
how Git handles line endings is 
[the one written by Tim Clem](http://timclem.wordpress.com/2012/03/01/mind-the-end-of-your-line/). 
The only thing to mention is what I wanted and how I set it up: only Line-Feed (LF) wanted in the database, 
and platform dependent line endings in the working copy. This means also LF on Unices but CRLF on Windows.

Add the following to a `.gitattributes` file in the root of your repository:

{{< gist id="168c2cf7726a536deb9c" file=".gitattributes" >}}

Add additional suffixes that you need mapped to either text or binary type. Now commit this file in your repository:

{{< gist id="168c2cf7726a536deb9c" file="add-gitattributes.sh" >}}

As you can see from the code samples, everything is executed on a Unix machine. As the content in the TFS 
repository contains Windows line endings, we need a single full conversion to make sure that everything 
is not correctly normalized:

{{< gist id="168c2cf7726a536deb9c" file="convert-line-endings.sh" >}}

The working copy was removed, we checked out a new working copy with our new settings active. This results in 
a all text files having LF only now. We add all these changed files to the staging area and commit them. 
The database now correctly contains LF only for text files.

## Results

Our workstation now contains a Git repository with a single master branch, with correct author information and 
normalized line endings working on all platforms. The only thing left to do is to push this to the new Git server 
and let the team work on it:

{{< gist id="168c2cf7726a536deb9c" file="push-to-server.sh" >}}

That's all folks!

If you have comments or questions, please leave them below!