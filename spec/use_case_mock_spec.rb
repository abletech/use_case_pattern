require "spec_helper"
require "use_case_mock"

describe UseCaseMock do
  let(:mock) { UseCaseMock.new(results: ['result_1', 'result_2']) }

  describe "#perform" do
    context "when the including class has defined a perform method" do
      it "should call the perform method" do
        expect(UseCaseMock).to receive(:perform)
        UseCaseMock.perform
      end
    end

    context "when the including class has defined a perform method and initializer" do
      subject(:result){ UseCaseMock.perform(number: 10) }

      it "should call the initializer" do
        expect(UseCaseMock).to receive(:new).with(number: 10).and_call_original
        result
      end

      it "should have no errors" do
        expect(result.errors.full_messages).to eq([])
      end

      it "should return the use case object" do
        expect(result.class).to eq(UseCaseMock)
      end

      it "returns the correct attribute readers" do
        expect(result.number).to eql 10
      end
    end

    context "with a use case that generates errors" do
      subject(:result) { UseCaseMock.perform }

      before do
        result.errors.add(:age, "can't be blank")
      end

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
        it "does not raise an error" do
          expect { result.perform! }.not_to raise_error(UseCasePattern::ValidationError, "Validation failed: Age can't be blank")
        end
      end
    end
  end
end