describe Sinatra::Param::Validations::MatchValidation do
  context 'when parameter type and match class do not match' do
    it 'raises an ArgumentError' do
      message = 'match must be an Integer (given String)'

      expect { described_class.new(:foo, :integer, 1, match: 'bar') }.to raise_error(Sinatra::Param::ArgumentError, message)
    end
  end

  context 'when parameter value does not match expected value' do
    it 'raises an InvalidParameterError' do
      message = 'Parameter foo value "bar" must match biz'

      expect { described_class.new(:foo, :string, 'bar', match: 'biz').apply }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end
  end

  context 'when parameter value matches expected value' do
    it 'returns nil' do
      expect(described_class.new(:foo, :string, 'bar', match: 'bar').apply).to be(nil)
    end
  end
end
