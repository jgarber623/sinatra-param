describe Sinatra::Param::ArrayCoercion do
  context 'when given a non-Array-like String' do
    it 'returns an Array' do
      expect(described_class.apply(:foo, 'bar')).to eq(['bar'])
    end
  end

  context 'when given an Array-like String' do
    it 'returns an Array' do
      expect(described_class.apply(:foo, 'foo,bar')).to eq(%w[foo bar])
    end
  end

  context 'when given a custom delimiter' do
    it 'returns an Array' do
      expect(described_class.apply(:foo, 'foo|bar', delimiter: '|')).to eq(%w[foo bar])
    end
  end
end
