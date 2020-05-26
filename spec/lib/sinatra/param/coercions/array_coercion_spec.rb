RSpec.describe Sinatra::Param::Coercions::ArrayCoercion do
  context 'when given a non-Array-like String' do
    it 'returns an Array' do
      expect(described_class.new(:foo, 'bar').apply).to eq(['bar'])
    end
  end

  context 'when given an Array-like String' do
    it 'returns an Array' do
      expect(described_class.new(:foo, 'foo,bar').apply).to eq(%w[foo bar])
    end
  end

  context 'when given a custom delimiter' do
    it 'returns an Array' do
      expect(described_class.new(:foo, 'foo|bar', delimiter: '|').apply).to eq(%w[foo bar])
    end
  end
end
