describe Sinatra::Param::Coercions::HashCoercion do
  context 'when given a non-Hash-like String' do
    it 'raises an InvalidParameterError' do
      message = 'Parameter foo value "bar" must be a Hash'

      expect { described_class.new(:foo, 'bar').apply }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end
  end

  context 'when given a Hash-like String' do
    it 'returns a Hash' do
      expect(described_class.new(:foo, 'foo:bar,biz:baz,,,,buz:').apply).to eq('foo' => 'bar', 'biz' => 'baz', 'buz' => nil)
    end
  end

  context 'when given a custom delimiter' do
    it 'returns a Hash' do
      expect(described_class.new(:foo, 'foo:bar|biz:baz', delimiter: '|').apply).to eq('foo' => 'bar', 'biz' => 'baz')
    end
  end

  context 'when given a custom separator' do
    it 'returns a Hash' do
      expect(described_class.new(:foo, 'foo|bar', separator: '|').apply).to eq('foo' => 'bar')
    end
  end

  context 'when customer delimiter and custom separator are equal' do
    it 'raises an ArgumentError' do
      message = 'delimiter and separator cannot be the same'

      expect { described_class.new(:foo, 'bar', delimiter: ',', separator: ',') }.to raise_error(Sinatra::Param::ArgumentError, message)
    end
  end
end
