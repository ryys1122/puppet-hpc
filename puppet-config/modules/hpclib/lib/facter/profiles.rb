require 'yaml'
require 'hiera'
require_relative 'role'

# Please maintain this list in the documentation (README.md)
tracked_profiles=['server','relay','mirror','replica','tracker', 'proxy']

hiera_cfg_file = File.join(Hiera::Util.config_dir, 'puppet/hiera.yaml')

myprofiles = Array.new
profiles = Hash.new
roles = Facter.value(:hosts_by_role).keys()
myrole = Facter.value(:puppet_role)

options = {
  :default => nil,
  :config => hiera_cfg_file,
  :scope => {
    'environment' => Puppet[:environment],
    'cluster_name' => Facter.value(:cluster_name),
  },
  :key => nil,
  :verbose => false,
  :resolution_type => :priority
}

begin
  hiera = Hiera.new(:config => options[:config])
  rescue Exception => e
  if options[:verbose]
    raise
  else
    STDERR.puts "Failed to start Hiera: #{e.class}: #{e}"
    exit 1
  end
end

unless options[:verbose]
  Hiera.logger = "noop"
end

########################################
options[:key] = "profiles"
roles.each do |currole|
  curprofiles = Array.new
  options[:scope] = {
    'environment' => Puppet[:environment],
    'cluster_name' => Facter.value(:cluster_name),
    "puppet_role" => currole,
  }
  curprofiles = hiera.lookup(options[:key], options[:default], options[:scope], nil, options[:resolution_type])
  if ! curprofiles.nil?
    profiles[currole] = curprofiles
    if currole == myrole
      myprofiles = curprofiles
    end
    curprofiles.each do |prof|
      expr=prof.split('::')
      tracked_profiles.each do |keywd|
        if expr[2] == keywd 
          currfact='my_'+expr[1]+'_'+keywd
          Facter.add(currfact) do
            setcode do
              currole
            end
          end
        end
      end
    end
  end
end

Facter.add('myprofiles') do
  setcode do
    myprofiles
  end
end

Facter.add('profiles') do
  setcode do
    profiles
  end
end

