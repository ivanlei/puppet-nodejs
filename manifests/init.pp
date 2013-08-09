# == Class: node
# Installs NodeJS from source after installing its dependencies
#  Follows instructions from: http://howtonode.org/how-to-install-nodejs
#
# === Actions
#  - Installs dependency packages
#  - Downloads and builds Node
#  - Installs Node
#
# === Example
# class { 'nodejs': }
#
class nodejs {
  require git

  $packages = ['g++', 'curl', 'libssl-dev', 'apache2-utils']
  $repo_path = '/tmp/node'

  package { $packages:
    ensure => present,
  }

  vcsrepo { $repo_path:
    ensure    => present,
    provider  => git,
    source    => 'git://github.com/ry/node.git',
    require   => Package[$packages]
  }

  exec { 'nodejs_install_1':
    command   => 'bash -c \'./configure\'',
    cwd       => $repo_path,
    logoutput => 'on_failure',
    path      => ['/usr/bin', '/usr/sbin', '/bin'],
    require   => Vcsrepo[$repo_path]
  }

  exec { 'nodejs_install_2':
    command   => 'bash -c \'make\'',
    timeout   => 600,
    cwd       => $repo_path,
    logoutput => 'on_failure',
    path      => ['/usr/bin', '/usr/sbin', '/bin'],
    require   => Exec['nodejs_install_1']
  }

  exec { 'nodejs_install_3':
    command   => 'bash -c \'sudo make install\'',
    cwd       => $repo_path,
    logoutput => 'on_failure',
    path      => ['/usr/bin', '/usr/sbin', '/bin'],
    require   => Exec['nodejs_install_2']
  }

  # The Exec above have cwd set to $repo_path, so they will by default autorequire File[$repo_path].
  # For any Exec that File[$repo_path] requires, the autorequire is ignored.
  # Unless File[$repo_path] requires all the Exec above, autorequires create a circular dependency.
  file { $repo_path:
    ensure    => absent,
    force     => true,
    require   => Exec['nodejs_install_1', 'nodejs_install_2', 'nodejs_install_3']
  }
}