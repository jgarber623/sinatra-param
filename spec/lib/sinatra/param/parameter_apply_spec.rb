describe Sinatra::Param::Parameter, :apply do
  context 'when given invalid Coercion arguments' do
    it 'raises an ArgumentError' do
      message = 'delimiter and separator cannot be the same'

      expect { described_class.new(:foo, :hash, nil, delimiter: ',', separator: ',').apply }.to raise_error(Sinatra::Param::ArgumentError, message)
    end
  end

  context 'when given valid Coercion arguments' do
    it 'coerces the value' do
      expect(described_class.new(:foo, :hash, 'foo:bar,biz:baz').apply).to eq('foo' => 'bar', 'biz' => 'baz')
    end
  end

  context 'when applying a Transformation' do
    context 'when argument value is a String' do
      it 'raises an ArgumentError' do
        message = 'transform must be a Proc or Symbol (given String)'

        expect { described_class.new(:foo, :string, 'bar', transform: 'biz').apply }.to raise_error(Sinatra::Param::ArgumentError, message)
      end
    end

    context 'when argument value is a Symbol' do
      it 'raises an ArgumentError' do
        message = 'transform ":biz" does not exist for value of type String'

        expect { described_class.new(:foo, :string, 'bar', transform: :biz).apply }.to raise_error(Sinatra::Param::ArgumentError, message)
      end
    end

    context 'when given a Symbol' do
      it 'transforms the value' do
        expect(described_class.new(:foo, :string, 'bar', transform: :upcase).apply).to eq('BAR')
      end
    end

    context 'when given a Proc' do
      it 'transforms the value' do
        expect(described_class.new(:foo, :string, 'bar', transform: ->(value) { value.upcase }).apply).to eq('BAR')
      end
    end
  end

  context 'when applying a Validation' do
    context 'when type is not a String' do
      it 'raises an ArgumentError' do
        message = 'type must be :string (given :integer)'

        expect { described_class.new(:foo, :integer, 1, format: %r{^https?://}).apply }.to raise_error(Sinatra::Param::ArgumentError, message)
      end
    end

    context 'when format is not a Regexp' do
      it 'raises an ArgumentError' do
        message = 'format must be a Regexp (given String)'

        expect { described_class.new(:foo, :string, nil, format: 'bar').apply }.to raise_error(Sinatra::Param::ArgumentError, message)
      end
    end

    context 'when value does not match format' do
      it 'raises an InvalidParameterError' do
        message = 'Parameter foo value "bar" must match format ^https?://'

        expect { described_class.new(:foo, :string, 'bar', format: %r{^https?://}).apply }.to raise_error(Sinatra::Param::InvalidParameterError, message)
      end
    end

    context 'when value matches format' do
      it 'validates the parameter' do
        expect(described_class.new(:foo, :string, 'https://example.com', format: %r{^https?://}).apply).to eq('https://example.com')
      end
    end
  end
end
