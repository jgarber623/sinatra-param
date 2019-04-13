describe Sinatra::Param::BooleanCoercion do
  context 'when given a non-Boolean-like String' do
    it 'raises an InvalidParameterError' do
      message = 'Parameter foo value "bar" must be a Boolean'

      expect { described_class.apply(:foo, 'bar') }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end
  end

  context 'when given a TrueClass-like String' do
    it 'returns a Boolean' do
      expect(described_class.apply(:foo, 'yes')).to be(true)
    end
  end

  context 'when given a FalseClass-like String' do
    it 'returns a Boolean' do
      expect(described_class.apply(:foo, '0')).to be(false)
    end
  end
end
