#!/usr/bin/perl -w
#
#Simple web crawler, iterates through a forum and archives the posts for each forum thread
#DISCLAIMER: Yeah I don't really know what characters I have to escape when writing them to strings so I sort of just escape anything that might be a little bit suspicious. I know I could easily look up what has to be escaped and what doesn't, but I don't think it will make much of a difference other than a few extra bits, which you can tell this comment is already taking more space than the extra back-slashes do so at least I know I won't have any unescaped characters
#TODO write page_links array to a file

use strict;
use LWP 6.36;
use HTTP::Cookies::Netscape;

my $crawlAg = LWP::UserAgent->new(); #UserAgent has cookie support. I dont know why I didn't use it in the first place. I don't even have to redo everything to use it.
$crawlAg->agent('Mozilla/5.0'); #I'm a REAL BOY!!
my $cook_jar = HTTP::Cookies::Netscape->new(file => "cookie.txt");
$crawlAg->cookie_jar({file => "cookie.txt"}); #Please eat the cookie. I need you to eat this cookie. Please.
my $url = "http:\/\/www.stearman.net\/fusetalk4\/forum\/"; #Identify the base of URL (I really don't feel like typing this over and over)
my @pagelinks; #Initialize so the value don't get overwritten every time i call GetLinks
print("Page Links array initialized\n");
my $html = $crawlAg->get("http:\/\/www.stearman.net\/fusetalk4\/forum\/categories.cfm\?catid\=3\&entercat\=y"); #Initial URL. This value changes throughout.
print("HTML extracted\n$html");
my $page_num = 1; #just to keep track of what page I'm on, I need it for being able to tell when the program should end.
my $token = qr/"messageview\.cfm\?catid\=3\&threadid\=.*?\&enterthread\=y"/; #The link format I'm looking for which denotes a new thread

sub GetLinks{
	print("GetLinks entered");
	while ($html =~ s/($token)[">]//){ #Find and replace token (defined above) with nothing
		my $cur_url = $url . $1; #use recently deleted token as directory from base URL
		print("cur_url = $cur_url\n");
		push @pagelinks, $cur_url; #put it in the list
	}
	$page_num++;
	print("exiting GetLinks");
}

print("Variables declared.\n");
GetLinks or die "Failed to call GetLinks";
$html = $crawlAg->get($url . "categories.cfm\?catid\=3\&FTVAR\_SORT\=date\&FTVAR\_SORTORDER\=desc\&STARTPAGE\=2\&FTVAR\_FORUMVIEWTMP\=Linear");
GetLinks; #gotta remember to scan and save the second page, I almost forgot this
while($page_num >= 2 && get ($url . "categories.cfm\?catid\=3\&FTVAR\_SORT\=date\&FTVAR\_SORTORDER\=desc\&STARTPAGE\=" . $page_num . "\&FTVAR\_FORUMVIEWTMP\=Linear")){ #This goes through every page that exists and downloads its list of threads
	$html = $crawlAg->get($url . "categories.cfm\?catid\=3\&FTVAR\_SORT\=date\&FTVAR\_SORTORDER\=desc\&STARTPAGE\=" . $page_num . "\&FTVAR\_FORUMVIEWTMP\=Linear");
	GetLinks;
}
open my $fh, '>', "linklist.txt" or die "Cannot open linklist.txt: $!"; #Open file handler, make sure it worked, or give up (please dont give up, it would have gone through so much for nothing...)
foreach (@pagelinks){
	print $fh "$_\n"; #write array to txt file, new line for each item
}
close $fh;
die "Completed successfully.";



