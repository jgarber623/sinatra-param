describe Sinatra::Param::FloatCoercion do
  context 'when given a non-Float-like Sring' do
    it 'raises an InvalidParameterError' do
      message = 'Parameter value "foo" must be a Float'

      expect { described_class.apply('foo') }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end
  end

  context 'when given a Float-like String' do
    it 'returns a Float' do
      expect(described_class.apply('1.0')).to eq(1.0)
    end
  end

  context 'when given a Float' do
    it 'returns a Float' do
      expect(described_class.apply(1.0)).to eq(1.0)
    end
  end
end
