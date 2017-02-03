require 'active_model/serializer/reflection'

module ActiveModel
  class Serializer
    class Reflection < Field
      def authorize?
        !!options[:authorize]
      end

      def value_with_cancan(serializer, include_slice)
        val = value_without_cancan(serializer, include_slice)
        unless authorize?
          return val
        end
        if val.kind_of?(Array)
          val.select do |item|
            serializer.current_ability.can?(:read, item)
          end
        else
          if serializer.current_ability.can?(:read, val)
            val
          else
            nil
          end
        end
      end
      alias_method_chain :value, :cancan
    end
  end
end
