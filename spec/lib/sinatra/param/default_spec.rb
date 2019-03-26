describe Sinatra::Param::Default do
  context 'when no default given' do
    it 'returns a String' do
      expect(described_class.apply('foo')).to eq('foo')
    end
  end

  context 'when default is a Proc' do
    it 'returns a String' do
      expect(described_class.apply(nil, default: -> { 'foo' })).to eq('foo')
    end
  end

  context 'when default is a String' do
    it 'returns a String' do
      expect(described_class.apply(nil, default: 'foo')).to eq('foo')
    end
  end
end
