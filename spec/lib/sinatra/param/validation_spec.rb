describe Sinatra::Param::Validation do
  describe '.for_options' do
    it 'returns an Array' do
      expect(described_class.for_options(format: %r{^https?://}, required: true)).to include(Sinatra::Param::FormatValidation, Sinatra::Param::RequiredValidation)
    end
  end

  describe '.supported_validations' do
    it 'returns an Array' do
      expect(described_class.supported_validations).to eq([:format, :in, :max, :min, :required, :within])
    end
  end
end
