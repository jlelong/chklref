#
# Regular cron jobs for the chklref package
#
0 4	* * *	root	[ -x /usr/bin/chklref_maintenance ] && /usr/bin/chklref_maintenance
