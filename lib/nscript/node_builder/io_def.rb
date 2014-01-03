module NScript
  module NodeBuilder
    class IODef
      def initialize(name)
        @name = name.to_sym 
      end

      def name
        @name
      end
    end
  end
end