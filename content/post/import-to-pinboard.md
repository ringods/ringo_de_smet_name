+++
date = "2017-01-29T18:36:37+02:00"
title = "Import the Delicious dump into Pinboard"
slug = "import-delicious-into-pinboard"
+++

In a [previous article](/2017/01/exporting-delicious-bookmarks-2017/), I explained how to dump all your bookmarks from Delicious using a web scraper. As I'm switching to [Pinboard](https://pinboard.in), I still needed a way to import the exported bookmarks

<!--more-->

# Content structure

The exported bookmark file is a CSV file, but with a snippet of JSON for the bookmark tags:

```
"Lifehacker","http://lifehacker.com/","[{""tag"":""gtd""},{""tag"":""news""},{""tag"":""productivity""}]","tips and downloads for getting things done"
```

# Import

The Pinboard API is fully documented online. To import the CSV file into Pinboard, I wrote a little Python script to process line by line. 

{{< gist id="bedde975e6e92a77e2321487ba45f313" file="import_to_pinboard.py" >}}

Each line is converted from the CSV/JSON structure to a URL encoded set of arguments. These arguments are then used in an HTTP call to create the bookmark at Pinboard.

# Run

Download a local copy of my script, update the variables at the beginning with the name of your dump file and put your Pinboard account token. You can find this token in the [Pinboard Password settings](https://pinboard.in/settings/password).
