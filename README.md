# server-backups
# README #

This repository holds all the bash scripts needed to locally back up all of innovatives databases and webservers

This should be used injunction with rsnapshot

### Setting Up ###

1. on backup server cd into /usr/local/sbin
2. pull contents of this repository into sbin
3. update files as needed
4. Set up cronjob 
* ```sudo nano /etc/crontab```

Add: 
~~~~

	# for syncing the dbs 
	34 *	* * *	username sh /usr/local/sbin/syncdbs.sh > /var/log/cronlogs/syncdbs.log
	25 *	* * *	username bash /usr/local/sbin/syncdbs2.sh > /var/log/cronlogs/syncdbs2.log
	00 2	* * *	root /usr/local/sbin/dumpdbs.sh > /var/log/cronlogs/dumpdbs.log
	
	# for syncing the html folders on the servers
	50 *	* * *	username sh /usr/local/sbin/synchtml.sh > /var/log/cronlogs/synchtml.log

	# the dead mans snitch to make sure that the backups pull down
	30 *	* * *	root	 bash /usr/local/sbin/dbbackupsnitch.sh > /var/log/cronlogs/dbbackupsnitch.log
	
~~~~
5. Set up cron logs


* [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)

### Setting Mongo DB Backups ###
1. copy backupmongo.sh into server with mongo db client place it: ``` /usr/bin/backupmongo.sh```
2. set up crontab on this server 
~~~
	# backup the mongo files
	10 03   * * *   root    cd /datadrive/backups/mongo &&  /bin/bash /usr/bin/backupmongo.sh >> /var/log/cronjobs/backupmongo.log
~~~
3. edit syncdb2.sh on backup server to point to this server
### Backing Up Databases ###

#### Azure Databases ####
1. edit dumpdbs.sh and add database to or from array

#### Webserver Databases ####
1. edit syncdbs.sh

### To Do ###
* clean up database scripts into one, only one is needed

### RSANP ###

1. checkout https://wiki.archlinux.org/index.php/Rsnapshot
2. set up cronjob on backup server

~~~
	# for syncing the dbs 
	34 *	* * *	username sh /usr/local/sbin/syncdbs.sh > /var/log/cronlogs/syncdbs.log
	25 *	* * *	username bash /usr/local/sbin/syncdbs2.sh > /var/log/cronlogs/syncdbs2.log
	00 2	* * *	root /usr/local/sbin/dumpdbs.sh > /var/log/cronlogs/dumpdbs.log

	# for syncing the html folders on the servers
	50 *	* * *	username sh /usr/local/sbin/synchtml.sh > /var/log/cronlogs/synchtml.log

	# the dead mans snitch to make sure that the backups pull down
	30 *	* * *	root	 bash /usr/local/sbin/dbbackupsnitch.sh > /var/log/cronlogs/dbbackupsnitch.log

	# for incremental backups of the local copies of the html and dbs
	# see /etc/rsnapshot.conf for more details on the setup
	00 */4	* * *	root	/usr/bin/rsnapshot alpha > /var/log/cronlogs/alpha.log # keeps 6 backups once every 4 hours for 6 saves in 24 hours
	55 23	* * *	root	/usr/bin/rsnapshot beta > /var/log/cronlogs/beta.log # keeps 7 backups once every day for 7 saves a week
	45 22	* * 0	root	/usr/bin/rsnapshot gamma > /var/log/cronlogs/gamma.log # keeps 4 backups once every sunday for 4 saves a month
~~~
