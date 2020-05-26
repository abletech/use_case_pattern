require "active_support"
require "active_model"

module UseCasePattern
  module Base
    extend ActiveSupport::Concern
    include ActiveModel::Validations

    module ClassMethods
      # The perform method of a UseCase should always return itself
      def perform(*args)
        use_case(*args).tap do |use_case|
          if use_case.valid?
            use_case.perform
          end
        end
      end

      # Raise a validation error if perform has created any errors
      def perform!(*args)
        use_case(*args).tap { |use_case| use_case.perform! }
      end

      private 

      # initialises the use_case, making sure that any keyword arguments are
      # dealt with appropriately: https://piechowski.io/post/last-arg-keyword-deprecated-ruby-2-7/
      def use_case(*args)
        if args.last.is_a?(Hash)
          keyword_arguments = args.pop
          new(*args, **keyword_arguments)
        else
          new(*args)
        end
      end
    end

    # Implement all the steps required to complete this use case
    def perform
      raise NotImplementedError
    end

    def perform!
      if invalid?
        raise(ValidationError.new(self))
      end

      perform
    end

    # Did the use case performed its task without errors?
    def success?
      errors.none?
    end

    # Did the use case have any errors?
    def failure?
      errors.any?
    end
  end

  # Use Case Pattern ValidationError
  #
  # Raised by <tt>perform!</tt> when validations result in errors.
  #
  # Check the use case +errors+ object for attribute error messages.
  #
  # ActiveModel 5.0 has an ActiveModel::ValidationError class, prior versions including 4.2 do not.
  #
  # This class may be deprecated by ActiveModel::ValidationError in the future.
  #
  class ValidationError < StandardError
    attr_reader :model

    def initialize(model)
      @model = model
      errors = @model.errors.full_messages.join(", ")
      super("Validation failed: " + errors)
    end
  end
end
