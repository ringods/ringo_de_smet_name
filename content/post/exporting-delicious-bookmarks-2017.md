+++
date = "2017-01-26T22:17:00+02:00"
title = "Exporting Delicious Bookmarks anno 2017"
slug = "exporting-delicious-bookmarks-2017"
+++

The Export tab in your [Delicious](https://del.icio.us/export) bookmarks account shows it has been disabled due to heavy load on the database. Too bad, but that doesn't prevent me from using the web scraping trick to download all my bookmarks.

<!--more-->

# What scraper to use?

To select the elements to scrape directly on a Delicious page, I use [Web Scraper](https://chrome.google.com/webstore/detail/web-scraper/jnhgnonknehpejjnehehllkliplmbmhn) from Martins Balodis. The documentation on [webscraper.io](http://webscraper.io/documentation) is very clear. The Web Scraper is integrated with the Chrome Developer Tools, so open these to find the Web Scraper functionality.

# Creating a sitemap

A Web Scraper sitemap is a description of the elements you want to scrape from the webpage, taking into account that each bookmarks page contains a subset of your total collection.

{{< gist id="3ac30de8ee28fadefa318ae857b365c5" file="sitemap.conf" >}}

The sitemap also contains the set of URL's to scrape. At the end of the file above, you will see the `startUrl` section. Replace `<your_account_id> with your Delicious account name.
I listed the start page followed by the enumeration from page 2 up to the maximum page number you have in your collection. Before you replace `<your_maximum_page>` with your real total number, try first with a small subset, e.g. `2-5`.

Under `Create new sitemap`, you can `Import sitemap`.

Now start scraping.

When the scraping is done, you can `Browse` the results under the `Sitemap` section. But `Export as CSV` now to be able to post process them.
