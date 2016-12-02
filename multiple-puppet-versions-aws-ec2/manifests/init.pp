# A tiny wrapper to class to prove loading an external
# module works correctly
class local_apache {

  include ::apache


  file { '/tmp/broken_file_mode':
    ensure => 'present',
    # this mode breaks on puppet 4, but not on puppet 3
    mode   => 0644,
  }

}
