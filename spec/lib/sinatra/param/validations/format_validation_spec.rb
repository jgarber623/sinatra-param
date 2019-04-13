describe Sinatra::Param::FormatValidation do
  context 'when given an Integer parameter type' do
    it 'raises an ArgumentError' do
      message = 'type must be :string (given :integer)'

      expect { described_class.apply(:foo, 'bar', :integer, format: %r{^https?://}) }.to raise_error(Sinatra::Param::ArgumentError, message)
    end
  end

  context 'when given a String parameter type' do
    context 'when given a non-Regexp format value' do
      it 'raises an ArgumentError' do
        message = 'format must be a Regexp (given String)'

        expect { described_class.apply(:foo, 'bar', :string, format: '^https?://') }.to raise_error(Sinatra::Param::ArgumentError, message)
      end
    end

    context 'when parameter value does not match format Regexp' do
      it 'raises an InvalidParameterError' do
        message = 'Parameter foo value "bar" must match format ^https?://'

        expect { described_class.apply(:foo, 'bar', :string, format: %r{^https?://}) }.to raise_error(Sinatra::Param::InvalidParameterError, message)
      end
    end

    context 'when paramater value matches format Regexp' do
      it 'returns nil' do
        expect(described_class.apply(:foo, 'https://example.com', :string, format: %r{^https?://})).to be(nil)
      end
    end
  end
end
