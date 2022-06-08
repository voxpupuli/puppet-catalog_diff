# A class to configure the diff viewer webservice. For full details, see
# https://github.com/camptocamp/puppet-catalog-diff-viewer
class catalog_diff::viewer (
  String  $remote    = 'https://github.com/camptocamp/puppet-catalog-diff-viewer.git',
  String  $password  = 'puppet',
  String  $revision  = 'master',
  Integer $port      = 1495,
  String  $listen_ip = $facts['networking']['ip'],
) {
  require git

  class { 'apache':
    default_vhost     => false,
    default_ssl_vhost => false,
  }

  apache::vhost { "${listen_ip}:${port}":
    servername  => $facts['networking']['fqdn'],
    ip          => $listen_ip,
    docroot     => '/var/www/diff',
    ip_based    => true,
    directories => [
      { path            => '/var/www/diff',
        auth_type       => 'Basic',
        auth_name       => 'Catalog Diff',
        auth_user_file  => '/var/www/.htpasswd',
        auth_group_file => '/dev/null',
        auth_require    => 'valid-user',
        allow_override  => 'AuthConfig',
      },
    ],
    priority    => '15',
    require     => Htpasswd['puppet'],
    port        => $port,
    add_listen  => true,
  }

  htpasswd { 'puppet':
    username    => 'puppet',
    cryptpasswd => htpasswd::ht_crypt($password, $facts['dmi']['product']['uuid']),
    target      => '/var/www/.htpasswd',
  }

  include apache::params

  file { '/var/www/.htpasswd':
    ensure => 'file',
    owner  => $apache::params::user,
    group  => $apache::params::group,
    mode   => '0700',
    before => Htpasswd['puppet'],
  }

  vcsrepo { '/var/www/diff':
    ensure   => latest,
    provider => 'git',
    source   => $remote,
    revision => $revision,
  }
}
