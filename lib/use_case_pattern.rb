require "use_case_pattern/version"
require "use_case_pattern/base"

module UseCasePattern
  def self.included(receiver)
    receiver.send :include, UseCasePattern::Base
  end
end
