define beluga::user (
  $uid,
  $realname = '',
  $pass = '',
  $key_type = '',
  $ssh_key = '',
  $groups = [],
) {
  $homepath =  $beluga::params::home
  $shell    =  $beluga::params::shell

  user { $name:
    ensure            =>  'present',
    uid               =>  $uid,
    gid               =>  $title,
    groups            =>  $groups,
    shell             =>  $shell,
    home              =>  "${homepath}/${name}",
    comment           =>  $realname,
    password          =>  $pass,
    managehome        =>  true,
    require           =>  Group[$name],
  }

  group { $name:
    gid               => $uid,
  }

  file { "${homepath}/${name}":
    ensure            =>  directory,
    owner             =>  $name,
    group             =>  $name,
    mode              =>  '0755',
    require           =>  [ User[$name], Group[$name] ],
  }
  if ($ssh_key != '') {
    beluga::user::key{"${name}_default":
      user => $name,
      ssh_key => $ssh_key,
      key_type => $key_type
    }
  }
}

define beluga::user::key(
  $user,
  $ssh_key,
  $key_type,
){
  $homepath =  $beluga::params::home
  ssh_authorized_key {$name:
      ensure          => present,
      name            => $name,
      user            => $user,
      type            => $key_type,
      key             => $ssh_key,
      target          => "${homepath}/${user}/.ssh/authorized_keys",
  }
}
