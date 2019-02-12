#!/bin/bash
#Uses curl to get and make cookie file, then runs crawler1.pl and crawler2.pl.

curl --cookie-jar "cookie.txt" -u 450:Aal112817 http://www.stearman.net/fusetalk4/forum/loginlocked.cfm
perl crawler1.pl
