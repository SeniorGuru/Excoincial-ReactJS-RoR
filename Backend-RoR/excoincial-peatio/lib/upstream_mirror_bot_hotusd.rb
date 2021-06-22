Arke
Arke::Command.run!(File.basename(__FILE__, '.*').split('_')[-1])
config = Arke::Configuration.require!(:strategy)
reactor = Arke::Reactor.new(config)
reactor.run


