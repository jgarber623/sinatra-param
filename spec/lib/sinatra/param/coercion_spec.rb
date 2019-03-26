describe Sinatra::Param::Coercion do
  describe '.for_type' do
    it 'returns an Array' do
      expect(described_class.for_type(:string)).to eq(Sinatra::Param::StringCoercion)
    end
  end

  describe '.supported_coercions' do
    it 'returns an Array' do
      expect(described_class.supported_coercions).to eq([:array, :boolean, :float, :hash, :integer, :string])
    end
  end
end
