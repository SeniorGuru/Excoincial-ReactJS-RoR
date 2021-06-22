require 'clamp'
require 'yaml'

module Arke
  module Command
    def run!(strategy_tag = 'strategy')
      load_configuration(strategy_tag)
      Arke::Log.define
      Root.run
    end
    module_function :run!

    def load_configuration(strategy_tag = 'strategy')
      config = YAML.load_file('config/strategy.yaml')

      Arke::Configuration.define { |c| c.strategy = config[strategy_tag] }
    end
    module_function :load_configuration

    # NOTE: we can add more features here (colored output, etc.)
  end
end
