#!/usr/bin/perl -w
#
#Second part of my perl crawler app. This one takes the word list created by the first part, parses the HTML from each URL, and saves just the post bodies.

use strict;
use LWP::Simple;
use Time::HiRes ('sleep');
use LWP::Simple::Cookies (autosave => 1, file => `cookie.txt`);

open $fh, '<', linklist.txt or die "Could not open linklist file. You should not see this error message."; #open link list file created by crawler1
my $tracker = 0; #keep track of what link we've followed, use this to make the txt files of the body text
my $html;

while (my $curlink = <$fh>){ #iterates through each link in the file, gets the HTML, and 
	chomp $curlink;
	$html = get($curlink);
	GetBody($html);
}

sub GetBody{
	while ($_ =~ s/("<p>"s+)[</p>]//){ #Find and replace body text with nothing, ending with the </p>
		open $fha, '>>', $tracker.txt or die "Could not write text to file: $!";
		my $cur_body = substr $1, 3; #the current body, minus the initial <p>
		print $fha "$cur_body\n\n";
		close $fha;
	}
	$tracker++;
}
