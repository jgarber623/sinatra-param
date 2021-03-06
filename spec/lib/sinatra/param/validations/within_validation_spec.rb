RSpec.describe Sinatra::Param::Validations::WithinValidation do
  context 'when given a non-Range in value' do
    it 'raises an ArgumentError' do
      message = 'within must be a Range (given String)'

      expect { described_class.new(:foo, :string, 'bar', within: 'biz') }.to raise_error(Sinatra::Param::ArgumentError, message)
    end
  end

  context 'when given a Range within value' do
    context 'when parameter value is not within specified values' do
      it 'raises an InvalidParameterError' do
        message = 'Parameter foo value "50" must be within 1 and 10'

        expect { described_class.new(:foo, :integer, 50, within: (1..10)).apply }.to raise_error(Sinatra::Param::InvalidParameterError, message)
      end
    end

    context 'when parameter value is within specified values' do
      it 'returns nil' do
        expect(described_class.new(:foo, :integer, 5, within: (1..10)).apply).to be(nil)
      end
    end
  end
end
