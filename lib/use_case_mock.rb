require 'ostruct'

class UseCaseMock < OpenStruct
  include UseCasePattern

  def perform
    self
  end
end