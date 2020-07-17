#!/bin/bash

###
### Install some global programs on the users machine
###

ROOT=$(pwd)

echo "Current working directory: ${ROOT}"

#ensure git is installed already
if hash git 2>/dev/null; then
	echo "Git is installed already"
else
	echo "You must install git before running build.sh"
	exit 1;
fi

#ensure hg is installed already
#if hash hg 2>/dev/null; then
#	echo "Hg is installed already"
#else
#	echo "You must install hg before running build.sh"
#	exit 1;
#fi

# get composer 
if hash composer 2>/dev/null; then
	echo "Composer is installed already"
else
	curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/local/bin/composer
fi

# get node

if hash node 2>/dev/null; then
	echo "Node is installed already"
else
	echo "You must install node before running build.sh"
	exit 1;
fi

if hash npm 2>/dev/null; then
	echo "Npm is installed already"
else
	echo "You must install npm before running build.sh"
	exit 1;
fi

if hash bower 2>/dev/null; then
	echo "bower is installed already"
else
	npm install -g bower
fi

if hash gulp 2>/dev/null; then
	echo "Gulp is installed already"
else
	npm install -g gulp
fi

currentVersion=$(php --version | head -n 1 | cut -d " " -f 2 | cut -c 1,3);
minimumRequiredVersion=7;
if [ $(echo " $currentVersion >= $minimumRequiredVersion" | bc) -eq 1 ]; then
    # Notify that the versions are matching
    echo "PHP Version is valid ...";
else
    # Else notify that the version are not matching
    echo "PHP Version NOT valid for ${currentVersion} ... requires ${minimumRequiredVersion}";
    # Kill the script
    exit 1;
fi

########################################################################
## Define some functions for reuse
########################################################################

# go to the correct folder
function back_to_main {
	eval cd "$ROOT"
	echo "Back to root dir..."
}

# clone for git
function clone {
	echo "Clone down $1..."
	#  --depth 1
	git clone --depth 1 git@github.com:ddell003/$1.git services/$1
	echo "Done with clone of $1..."
}

# clone for mercurial
function clone_hg {
	echo "Clone down $1..."
	#  --depth 1
	hg clone ssh://hg@bitbucket.org/ddell/$1 services/$1
	echo "Done with clone of $1..."
}

#################################################################

# userservice
function setup_userservice {

	cd services/userservice-server
	cp .env.example .env
	cp build.xml.dist build.xml
	# needs to be run after the container is brought up
	# php artisan migrate
	echo "Done with setting up userservice-server..."
	back_to_main
}

if [ ! -d "services/userservice-server" ]; then
    clone userservice-server
    setup_userservice
fi

# eintranet
function setup_eintranet {
	cd services/eintranet-git
	cp .env.example .env
	cp build.xml.dist build.xml
	cp ci/index.php.dist ci/index.php
	cp ci/ci.php.dist ci/ci.php
	npm install
	bower install
	gulp --production --forAngular --forBootstrap
	# setup the rbac database stuff
	echo "Setup RBAC stuff..."
	rm ${ROOT}services/eintranet-git/vendor/owasp/phprbac/PhpRbac/database/database.config
	echo "<?php \$host='devsql';\$user='root';\$pass='irs22952';\$dbname='eintranet';\$adapter='mysqli';\$tablePrefix='rbac_';" >> ${ROOT}/services/eintranet-git/vendor/owasp/phprbac/PhpRbac/database/database.config
	echo "Done with RBAC stuff..."
	echo "Done with setting up eintranet..."
	back_to_main
}

if [ ! -d "services/eintranet-git" ]; then
    clone eintranet-git
    setup_eintranet
fi

# ecompliance
function setup_ecompliance {
	cd services/ecompliance-git
	cp application/config/config.php.dist application/config/config.php
	cp application/config/database.php.dist application/config/database.php
	cp application/config/email.php.dist application/config/email.php
	cp application/config/mongo.php.dist application/config/mongo.php
	cp build.xml.dist build.xml
	npm install
	back_to_main
}

if [ ! -d "services/ecompliance-git" ]; then
    clone ecompliance-git
    setup_ecompliance
fi

# irtc / ammonia training
function setup_irtc {
	cd services/irtc-git
	cp build.xml.dist build.xml
	cp app/config/settings.php.dist app/config/settings.php
	npm install
	npm install --save-dev gulp gulp-uglify gulp-concat gulp-rename gulp-cssmin gulp-less
	gulp build-bootstrap build-less build-js build-print
	back_to_main
}

if [ ! -d "services/irtc-git" ]; then
    clone irtc-git
    setup_irtc
fi

# econserve
function setup_econserve {
	cd services/econserve
	cp application/config/config.php.dist application/config/config.php
	cp application/config/database.php.dist application/config/database.php
	cp build.xml.dist build.xml
	back_to_main
}

if [ ! -d "services/econserve" ]; then
    clone_hg econserve
    setup_econserve
fi

##########################################
## Everything below here is hanging in gulp
##########################################

# recruiting
function setup_recruiting {
	cd services/recruiting-git
	cp .env.example .env
	cp build.xml.dist build.xml
	npm install
	# npm install --save-dev gulp laravel-elixir
	bower install
	gulp --production
	back_to_main
}

if [ ! -d "services/recruiting-git" ]; then
    clone recruiting-git
    setup_recruiting
fi

# EPSM
function setup_epsmv2 {
	cd services/epsm-v2
	cp build.xml.dist build.xml
	cp .env.example .env
	cp index.php.dist index.php
	npm install
	npm install gulp --save-dev
	bower install
	gulp --production
	back_to_main
}

if [ ! -d "services/epsm-v2" ]; then
    clone epsm-v2
    setup_epsmv2
fi

# bring everything back up and build the new containers
# back_to_main
docker-compose up --force-recreate -d

# run composer installs

cd services/eintranet-git
composer install
back_to_main

cd services/ecompliance-git
composer install
back_to_main

cd services/irtc-git
composer install
back_to_main

cd services/epsm-v2
composer install
back_to_main

echo "Donesky!"

