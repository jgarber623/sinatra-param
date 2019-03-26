describe Sinatra::Param::IntegerCoercion do
  context 'when given a non-Integer-like Sring' do
    it 'raises an InvalidParameterError' do
      message = 'Parameter value "foo" must be an Integer'

      expect { described_class.apply('foo') }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end
  end

  context 'when given an Integer-like String' do
    it 'returns an Integer' do
      expect(described_class.apply('1')).to eq(1)
    end
  end

  context 'when given an Integer' do
    it 'returns an Integer' do
      expect(described_class.apply(1)).to eq(1)
    end
  end
end
