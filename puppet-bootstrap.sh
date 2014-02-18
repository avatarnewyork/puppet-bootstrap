#!/bin/bash

# Supports
# RHEL/CentOS 5.8-6.x
# Fedora 18,19,20
# Debian 6,7
# Ubuntu 10.04 (Lucid), 12.04 (Precise), 12.10 (Quantal), 13.04 (Raring), 13.10 (Saucy)


# Init Vars
ENVIRONMENT="production"

if [ $# -lt 1 ];
then
    echo "Usage $0 <SERVER_IP> <ENVIRONMENT> <CUSTOMSCRIPTNAME>"
    exit 2
else
    SERVER_IP=$1
fi

if [ $2 ];
then
    ENVIRONMENT=$2
fi

# Determain CPU
CPU=`uname -p`

# Determain version, update software, install puppet 
if [ -f /etc/debian_version ]; then
    OS=debian
    VER=$(cat /etc/debian_version | cut -d '.' -f 1)
    if [ $VER = 7 ]; then
	SUB="wheezy"
    elif [ $VER = 6 ]; then
	SUB="squeeze"
    fi
    
    # Debian update & puppet install
    if [ SUB ]; then
	wget https://apt.puppetlabs.com/puppetlabs-release-$SUB.deb
	dpkg -i puppetlabs-release-$SUB.deb
	apt-get update
	apt-get -y install puppet
    fi
	
elif [ -f /etc/fedora-release ]; then
    OS=fedora
    VER=$(awk '/release/ {split($3,a,"."); print a[1];}' /etc/fedora-release)

    if [ $VER = "18" ]; then
	SUB=7
    elif [ $VER = "19" ]; then
	SUB=2
    elif [ $VER = "20" ]; then
	SUB=1
    fi

    # Fedora update & puppet install
    wget https://yum.puppetlabs.com/fedora/f$VER/products/$CPU/puppetlabs-release-$VER-$SUB.noarch.rpm
    rpm -Uvh puppetlabs-release-$VER-$SUB.noarch.rpm
    yum update -y
    yum install -y puppet

elif [ -f /etc/redhat-release ]; then
    OS=rhel
    VER=$(awk '/release/ {split($3,a,"."); print a[1];}' /etc/redhat-release)

    # RHEL CentOS update & puppet install
    wget https://yum.puppetlabs.com/el/5/products/$CPU/puppetlabs-release-$VER-7.noarch.rpm
    rpm -Uvh puppetlabs-release-$VER-7.noarch.rpm
    yum update -y
    yum install -y puppet

elif [ -f /etc/lsb-release && !$OS ]; then
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
    SUB=$DISTRIB_CODENAME

    # Ubuntu update & puppet install
    wget https://apt.puppetlabs.com/puppetlabs-release-$SUB.deb
    dpkg -i puppetlabs-release-$SUB.deb
    apt-get update
    apt-get -y install puppet
fi

# update hosts to include puppet master server
cat >> /etc/hosts <<EOF
$SERVER_IP puppet
EOF

# Configure Puppet to talk to our environment
cat >> /etc/puppet/puppet.conf <<EOF
[agent]
environment = $ENVIRONMENT
EOF

# set puppet service defaults
cat > /etc/default/puppet <<EOF
# Defaults for puppet - sourced by /etc/init.d/puppet
# Start puppet on boot?
START=NO
# Startup options
DAEMON_OPTS="--environment=$ENVIRONMENT"
EOF

# Run any custom init script before starting puppet
if [ -f $3 ];
then
    . $3
fi

# Start puppet agent
/usr/bin/puppet agent --environment $ENVIRONMENT

exit 0
