module NScript::Node::Helpers::Http
  
  def http
    @http ||= Client.new(context)
  end

  class Client
    def initialize(context)
      @context = context
    end  

    def get(url, options={})
      @context.backend.http_get(url, options)
    end  
  end
end