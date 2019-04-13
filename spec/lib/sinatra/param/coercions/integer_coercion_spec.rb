describe Sinatra::Param::IntegerCoercion do
  context 'when given a non-Integer-like Sring' do
    it 'raises an InvalidParameterError' do
      message = 'Parameter foo value "bar" must be an Integer'

      expect { described_class.apply(:foo, 'bar') }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end
  end

  context 'when given an Integer-like String' do
    it 'returns an Integer' do
      expect(described_class.apply(:foo, '1')).to eq(1)
    end
  end

  context 'when given an Integer' do
    it 'returns an Integer' do
      expect(described_class.apply(:foo, 1)).to eq(1)
    end
  end
end
