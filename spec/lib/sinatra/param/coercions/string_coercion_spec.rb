describe Sinatra::Param::Coercions::StringCoercion do
  context 'when given an Integer' do
    it 'returns a String' do
      expect(described_class.new(:foo, 1).apply).to eq('1')
    end
  end

  context 'when given a String' do
    it 'returns a String' do
      expect(described_class.new(:foo, 'bar').apply).to eq('bar')
    end
  end
end
