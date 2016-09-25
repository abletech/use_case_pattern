require "active_support"
require "active_model"

module UseCasePattern
  module Base
    extend ActiveSupport::Concern
    include ActiveModel::Validations

    module ClassMethods
      # The perform method of a UseCase should always return itself
      def perform(*args)
        new(*args).tap { |use_case| use_case.perform }
      end

      # Raise an exception if perform generates any errors
      def perform!(*args)
        new(*args).tap { |use_case| use_case.perform! }
      end
    end

    # Implement all the steps required to complete this use case
    def perform
      raise NotImplementedError
    end

    def perform!
      perform

      if failure?
        raise_validation_error
      end
    end

    # Has this use case performed its task successfully?
    def success?
      errors.none?
    end

    # Did this use case have any errors?
    def failure?
      errors.any?
    end
  end
end
