require 'active_model/serializer/reflection'

module ActiveModel
  class Serializer
    class Reflection < Field
      prepend ActiveModel::Serializer::CanCan::ReflectionValue

      def authorize?
        !!options[:authorize]
      end
    end
  end
end
