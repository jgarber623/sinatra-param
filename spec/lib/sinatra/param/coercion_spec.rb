describe Sinatra::Param::Coercion, '.supported_coercions' do
  it 'returns an Array' do
    expect(described_class.supported_coercions).to eq([:array, :boolean, :float, :hash, :integer, :string])
  end
end
