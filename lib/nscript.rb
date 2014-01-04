require "nscript/version"
require "docile"

module NScript
  def self.reset!
    self.nodes.clear!
  end
end

require "nscript/ext/boolean"

require "nscript/node_builder/io_def"
require "nscript/node_builder/var_def"
require "nscript/node_builder/base"
require "nscript/node_builder/manager"

require "nscript/var/base"
require "nscript/var/boolean"
require "nscript/var/float"
require "nscript/var/integer"
require "nscript/var/string"

require "nscript/node"
require "nscript/node/base"
require "nscript/node/variable_pipeline"
require "nscript/dsl"
require "nscript/variable_storage"
require "nscript/node"
require "nscript/context"
require "nscript/notifications"
