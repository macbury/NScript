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

      def to_var
        if @type == Integer
          NScript::Var::Integer.new(@default)
        elsif @type == Float
          NScript::Var::Float.new(@default)
        elsif @type == String
          NScript::Var::String.new(@default)
        else
          NScript::Var::Boolean.new(@default)
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