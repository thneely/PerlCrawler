#!/usr/bin/perl -w
#
#Simple web crawler, iterates through a forum and archives the posts for each forum thread
#DISCLAIMER: Yeah I don't really know what characters I have to escape when writing them to strings so I sort of just escape anything that might be a little bit suspicious. I know I could easily look up what has to be escaped and what doesn't, but I don't think it will make much of a difference other than a few extra bits, which you can tell this comment is already taking more space than the extra back-slashes do so at least I know I won't have any unescaped characters

use strict;
use LWP::Simple; #TODO Download and install
#TODO Add cookie support, you can't use this site unless cookies are availible

my $url = "http:\/\/www.stearman.net\/fusetalk4\/forum\/"; #Identify the base of URL (I really don't feel like typing this over and over)
my $max = 5000; #Max number of URLs I can have. I probably wont worry about it later and just get every single one.
my @pagelinks; #Initialize so the value don't get overwritten every time i call GetLinks
my $html = get("http:\/\/www.stearman.net\/fusetalk4\/forum\/categories.cfm\?catid\=3\&entercat\=y"); #Initial URL. This value changes throughout.
my $page_num = 1; #just to keep track of what page I'm on, I need it for being able to tell when the program should end.
my $token = qr/"messageview\.cfm\?catid\=3\&threadid\=?*\&enterthread\=y"/; #The link format I'm looking for which denotes a new thread

GetLinks($html);
$html = get($url . "categories.cfm\?catid\=3\&FTVAR\_SORT\=date\&FTVAR\_SORTORDER\=desc\&STARTPAGE\=2\&FTVAR\_FORUMVIEWTMP\=Linear");
GetLinks($html); #gotta remember to scan and save the second page, I almost forgot this
while($page_num >= 2 && get ($url . "categories.cfm\?catid\=3\&FTVAR\_SORT\=date\&FTVAR\_SORTORDER\=desc\&STARTPAGE\=" . $page_num . "\&FTVAR\_FORUMVIEWTMP\=Linear")){ #This goes through every page that exists and downloads its list of threads
	$html = get($url . "categories.cfm\?catid\=3\&FTVAR\_SORT\=date\&FTVAR\_SORTORDER\=desc\&STARTPAGE\=" . $page_num . "\&FTVAR\_FORUMVIEWTMP\=Linear");
	GetLinks($html);
}
print(@page_links);
die "No more pages to scan.";


sub GetLinks{
	while (($_ =~ s/($token)[">]//){ #Find and replace token (defined above) with nothing
		my $cur_url = $url . $1; #use recently deleted token as directory from base URL
		push @page_links, $cur_url; #put it in the list
	}
	$page_num++; #I'm done with this. Get it out of my...site.
}