describe Sinatra::Param::Coercions::IntegerCoercion do
  context 'when given a non-Integer-like Sring' do
    it 'raises an InvalidParameterError' do
      message = 'Parameter foo value "bar" must be an Integer'

      expect { described_class.new(:foo, 'bar').apply }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end
  end

  context 'when given an Integer-like String' do
    it 'returns an Integer' do
      expect(described_class.new(:foo, '1').apply).to eq(1)
    end
  end

  context 'when given an Integer' do
    it 'returns an Integer' do
      expect(described_class.new(:foo, 1).apply).to eq(1)
    end
  end
end
