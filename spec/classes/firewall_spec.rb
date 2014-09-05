require 'spec_helper'

describe 'firewall' do

  let :facts do
    {
      :kernel                 => 'Linux',
      :operatingsystem        => 'Debian',
      :operatingsystemrelease => 'wheezy',
    }
  end

  let :pre_condition do
    "firewall { '000 accept all icmp':
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
      state => ['RELATED', 'ESTABLISHED'],
      action  => 'accept',
    }"
  end

  it { should compile.with_all_deps }
  it { should have_firewall_resource_count(3) }
  it {
    skip("that_requires doesn't work with autorequire")
    should contain_firewall('001 accept all to lo interface').
      that_requires('Firewall[000 accept all icmp]') }
  it {
    skip("that_requires doesn't work with autorequire")
    should contain_firewall('002 accept related established rules').
      that_requires('Firewall[001 accept all to lo interface]') }

end
