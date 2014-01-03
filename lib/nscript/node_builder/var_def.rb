module NScript
  module NodeBuilder
    class VarDef
      TYPES = [Integer, Float, String, Boolean]
      def initialize(name, options)
        @name    = name
        @type    = TYPES.include?(options[:type]) ? options[:type] : Integer
        @default = options[:default] || default_value_for_type(@type)
      end

      def default_value_for_type(type)
        if @type == Integer
          0
        elsif @type == Float
          0.0
        elsif @type == String
          ""
        else
          false
        end
      end

      def type
        @type
      end

      def default
        @default
      end

      def name
        @name
      end
    end
  end
end