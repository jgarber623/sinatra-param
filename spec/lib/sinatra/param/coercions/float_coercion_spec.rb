describe Sinatra::Param::Coercions::FloatCoercion do
  context 'when given a non-Float-like Sring' do
    it 'raises an InvalidParameterError' do
      message = 'Parameter foo value "bar" must be a Float'

      expect { described_class.new(:foo, 'bar').apply }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end
  end

  context 'when given a Float-like String' do
    it 'returns a Float' do
      expect(described_class.new(:foo, '1.0').apply).to eq(1.0)
    end
  end

  context 'when given a Float' do
    it 'returns a Float' do
      expect(described_class.new(:foo, 1.0).apply).to eq(1.0)
    end
  end
end
