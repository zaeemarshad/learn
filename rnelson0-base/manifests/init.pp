# == Class: base
#
# Full description of class base here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { base:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Rob Nelson <rnelson0@gmail.com>
#
# === Copyright
#
# Copyright 2014 Rob Nelson
#
class base {

  include ::motd

  # SSH server and client
  class { '::ssh::server':
    options => {
      'PermitRootLogin' => 'yes',
      'Protocol' => '2',
      'SyslogFacility' => 'AUTHPRIV',
      'PasswordAuthentication' => 'yes',
      'GSSAPIAuthentication' => 'yes',
      'GSSAPICleanupCredentials' => 'yes',
      'AcceptEnv' => 'LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT LC_IDENTIFICATION LC_ALL LANGUAGE XMODIFIERS',
      'Subsystem' => '      sftp    /usr/libexec/openssh/sftp-server',
      'Banner' => '/etc/issue.net',
    },
  }
  class { '::ssh::client':
    options => {
      'Host *' => {
        'SendEnv'                   => 'LANG LC_*',
        'HashKnownHosts'            => 'yes',
        'GSSAPIAuthentication'      => 'yes',
        'GSSAPIDelegateCredentials' => 'no',
      },
    },
  }

  class { '::ntp':
    servers => [ '0.pool.ntp.org', '2.centos.pool.ntp.org', '1.rhel.pool.ntp.org'],
  }

  $defaultpass = '$6$nD909ONL$1qwS35SaB4TzatxANgnokos5AJ4gy6.E8eOKeIcOhHd\/V4eIFsyYSlvkB4f1G4ecvNXVSxx4UdQCRdS0dTBXX1'

  ::base::user { 'dave':
    state    => 'present',
    id       => 'dave',
    uid      => '507',
    pass     => $defaultpass,
    realname => 'Dave G. Smith - IT Administrator',
    sgroups  => [],
  }

}
