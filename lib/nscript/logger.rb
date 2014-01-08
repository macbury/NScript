require "logger"

module NScript
  class Logger
    def initialize(context)
      @logger  = ::Logger.new(STDOUT)
      @logger.formatter = proc do |severity, datetime, progname, msg|
        msg + "\n"
      end
      @context = context
      @context.notifications.on("triggered.event", self) { |payload| @logger.info "Triggered: #{payload[:event].inspect} with payload: #{payload[:payload].inspect}" }
    end
  end
end