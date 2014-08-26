class Puppet::Type::Firewall
  autorequire(:firewall) do
    catalog.resources.select { |r| (r.class.to_s == "Puppet::Type::Firewall") and (r.name <=> name) == -1  }.sort.last
  end
end
