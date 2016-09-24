require "spec_helper"

describe UseCasePattern::Base do
  describe "#perform" do
    context "when the including class has defined a perform method" do
      it "should call the perform method" do
        expect(SimpleUseCase).to receive(:perform)
        SimpleUseCase.perform
      end
    end

    context "when the including class has defined a perform method and initializer" do
      subject(:use_case){ UseCaseWithConstructor.perform(10) }

      it "should call the initializer" do
        expect(UseCaseWithConstructor).to receive(:new).with(10).and_call_original
        use_case
      end

      it "should have no errors" do
        expect(use_case.errors.full_messages).to eq([])
      end
    end
  end
end

class SimpleUseCase
  include UseCasePattern

  def perform
  end
end

class UseCaseWithConstructor
  include UseCasePattern

  def initialize(args)
    @args = args
  end

  def perform
  end
end
