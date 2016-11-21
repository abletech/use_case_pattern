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
      subject(:result){ UseCaseWithConstructor.perform(10) }

      it "should call the initializer" do
        expect(UseCaseWithConstructor).to receive(:new).with(10).and_call_original
        result
      end

      it "should have no errors" do
        expect(result.errors.full_messages).to eq([])
      end

      it "should return the use case object" do
        expect(result.class).to eq(UseCaseWithConstructor)
      end
    end

    context "with the including class forgets to implement the perform method" do
      it "should raise an error" do
        expect { UseCaseWithMissingPerformMethod.perform }.to raise_error(NotImplementedError)
      end
    end
  end

  context "with a use case that generates errors" do
    let(:result){ UseCaseThatGeneratesErrors.perform(nil) }

    describe "#success?" do
      subject(:success){ result.success? }
      it { expect(success).to eq(false) }
    end

    describe "#failure?" do
      subject(:failure){ result.failure? }
      it { expect(failure).to eq(true) }
    end

    describe "#errors" do
      subject(:errors){ result.errors }
      it { expect(errors.full_messages).to eq(["Age can't be blank"]) }
    end

    describe "#perform!" do
      it "should raise an error" do
        expect { UseCaseThatGeneratesErrors.perform!(nil) }.to raise_error(UseCasePattern::ValidationError, "Validation failed: Age can't be blank")
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

  def initialize(temperature)
    @temperature = temperature
  end

  def perform
  end
end

class UseCaseThatGeneratesErrors
  include UseCasePattern

  attr_reader :age

  validates :age, presence: true

  def initialize(age)
    @age = age
  end

  def perform
    valid?
  end
end

class UseCaseWithMissingPerformMethod
  include UseCasePattern
end
