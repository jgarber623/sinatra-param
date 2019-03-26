describe Sinatra::Param::StringCoercion do
  context 'when given an Integer' do
    it 'returns a String' do
      expect(described_class.apply(1)).to eq('1')
    end
  end

  context 'when given a String' do
    it 'returns a String' do
      expect(described_class.apply('foo')).to eq('foo')
    end
  end
end
