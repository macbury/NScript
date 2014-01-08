require "nscript/version"
require "docile"
require "json"
require "eventmachine"

module NScript
  def self.reset!
    self.nodes.clear!
  end
end

require "nscript/logger"
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

require "nscript/persister/save"
require "nscript/persister/load"

require "nscript/node"
require "nscript/node/helpers/base"
require "nscript/node/helpers/time"
require "nscript/node/helpers/http"

require "nscript/node/io"
require "nscript/node/io_pipeline"
require "nscript/node/variable_pipeline"
require "nscript/node/base"
require "nscript/node/node"
require "nscript/node/variable"

require "nscript/dsl"
require "nscript/variable_storage"
require "nscript/node"
require "nscript/context"
require "nscript/notifications"

require "nscript/backend/base"
require "nscript/backend/sync"
require "nscript/backend/eventmachine"