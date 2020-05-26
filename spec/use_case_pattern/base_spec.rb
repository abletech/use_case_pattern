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

    context "with a class containing a constructor with hash arguments" do 
      subject(:result){ UseCaseWithConstructorContainingHash.perform(name: "Bert", age: 5) }

      it "should have no errors" do
        expect(result.errors.full_messages).to eq([])
      end

      it "should return the use case object" do
        expect(result.class).to eq(UseCaseWithConstructorContainingHash)
      end

      it "should have set the name and age" do 
        expect(result.age).to eq(5)
        expect(result.name).to eq("Bert")
      end
    end

    context "with a class containing a constructor with multiple arguments" do 
      subject(:result){ UseCaseWithConstructorContainingStringAndHash.perform("Rocket", height: 50, width: 5) }

      it "should have no errors" do
        expect(result.errors.full_messages).to eq([])
      end

      it "should return the use case object" do
        expect(result.class).to eq(UseCaseWithConstructorContainingStringAndHash)
      end

      it "should have set the name and age" do 
        expect(result.label).to eq("Rocket")
        expect(result.height).to eq(50)
        expect(result.width).to eq(5)
      end
    end

    context "with a class containing a constructor with multiple hashes" do 
      subject(:result){ UseCaseWithConstructorContainingTwoHashes.perform({label: "Rocket"}, height: 50, width: 5) }

      it "should have no errors" do
        expect(result.errors.full_messages).to eq([])
      end

      it "should return the use case object" do
        expect(result.class).to eq(UseCaseWithConstructorContainingTwoHashes)
      end

      it "should have set the name and age" do 
        expect(result.label).to eq("Rocket")
        expect(result.height).to eq(50)
        expect(result.width).to eq(5)
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

class UseCaseWithConstructorContainingHash
  include UseCasePattern

  attr_reader :name, :age

  def initialize(name:, age:)
    @name = name
    @age = age
  end

  def perform
  end
end

class UseCaseWithConstructorContainingTwoHashes
  include UseCasePattern

  attr_reader :label, :height, :width

  def initialize(my_hash, height:, width:)
    @label = my_hash[:label]
    @height = height
    @width = width
  end

  def perform
  end
end

class UseCaseWithConstructorContainingStringAndHash
  include UseCasePattern

  attr_reader :label, :height, :width

  def initialize(label, height:, width:)
    @label = label
    @height = height
    @width = width
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
