RSpec.describe Sinatra::Param::Coercions::BooleanCoercion do
  context 'when given a non-Boolean-like String' do
    it 'raises an InvalidParameterError' do
      message = 'Parameter foo value "bar" must be a Boolean'

      expect { described_class.new(:foo, 'bar').apply }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end
  end

  context 'when given a TrueClass-like String' do
    it 'returns a Boolean' do
      expect(described_class.new(:foo, 'yes').apply).to be(true)
    end
  end

  context 'when given a FalseClass-like String' do
    it 'returns a Boolean' do
      expect(described_class.new(:foo, '0').apply).to be(false)
    end
  end
end
