Firewall_c2c
============

[![Puppet Forge](http://img.shields.io/puppetforge/v/camptocamp/firewall_c2c.svg)](https://forge.puppetlabs.com/camptocamp/firewall_c2c)
[![Build Status](https://travis-ci.org/camptocamp/puppet-firewall_c2c.png?branch=master)](https://travis-ci.org/camptocamp/puppet-firewall_c2c)

Overview
--------

Monkey Patch Puppetlabs' firewall module to add an autorequirement to apply Firewall resources alphabetically.

Example:
--------

Consider this manifest:

```puppet
class { 'firewall': }
firewall { '000 accept all icmp':
  proto   => 'icmp',
  action  => 'accept',
}
firewall { '001 accept all to lo interface':
  proto   => 'all',
  iniface => 'lo',
  action  => 'accept',
}
firewall { '002 accept related established rules':
  proto   => 'all',
  ctstate => ['RELATED', 'ESTABLISHED'],
  action  => 'accept',
}
```

Without this module, you have to add explicit dependencies, otherwise rules are applied whithout specific order:
```
Notice: /Stage[main]/Main/Firewall[000 accept all icmp]/ensure: current_value absent, should be present (noop)
Notice: /Stage[main]/Main/Firewall[002 accept related established rules]/ensure: current_value absent, should be present (noop)
Notice: /Stage[main]/Main/Firewall[001 accept all to lo interface]/ensure: current_value absent, should be present (noop)
```

With this module, no need to define explicit dependencies:
```
Notice: /Stage[main]/Main/Firewall[000 accept all icmp]/ensure: current_value absent, should be present (noop)
Notice: /Stage[main]/Main/Firewall[001 accept all to lo interface]/ensure: current_value absent, should be present (noop)
Notice: /Stage[main]/Main/Firewall[002 accept related established rules]/ensure: current_value absent, should be present (noop)
```

And with `--debug`:
```
Debug: /Firewall[000 accept all icmp]: Autorequiring Package[iptables]
Debug: /Firewall[000 accept all icmp]: Autorequiring Package[iptables-persistent]
Debug: /Firewall[001 accept all to lo interface]: Autorequiring Package[iptables]
Debug: /Firewall[001 accept all to lo interface]: Autorequiring Package[iptables-persistent]
Debug: /Firewall[001 accept all to lo interface]: Autorequiring Firewall[000 accept all icmp]
Debug: /Firewall[002 accept related established rules]: Autorequiring Package[iptables]
Debug: /Firewall[002 accept related established rules]: Autorequiring Package[iptables-persistent]
Debug: /Firewall[002 accept related established rules]: Autorequiring Firewall[001 accept all to lo interface]

```

This greatly ease the usage of Puppetlabs' firewall module.
