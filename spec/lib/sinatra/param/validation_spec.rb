describe Sinatra::Param::Validation, '.supported_validations' do
  it 'returns an Array' do
    expect(described_class.supported_validations).to eq([:format, :in, :match, :max, :min, :required, :within])
  end
end
