describe Sinatra::Param::Validations::MaxValidation do
  context 'when given a String parameter type' do
    it 'raises an ArgumentError' do
      message = 'type must be one of [:float, :integer] (given :string)'

      expect { described_class.new(:foo, :string, 'bar', max: 10) }.to raise_error(Sinatra::Param::ArgumentError, message)
    end
  end

  context 'when given an Integer parameter type' do
    context 'when given a non-Float max value' do
      it 'raises an ArgumentError' do
        message = 'max must be a Float or an Integer (given String)'

        expect { described_class.new(:foo, :integer, 10, max: 'biz') }.to raise_error(Sinatra::Param::ArgumentError, message)
      end
    end

    context 'when parameter value is greater than maximum allowed value' do
      it 'raises an InvalidParameterError' do
        message = 'Parameter foo value "100" may be at most 10'

        expect { described_class.new(:foo, :integer, 100, max: 10).apply }.to raise_error(Sinatra::Param::InvalidParameterError, message)
      end
    end

    context 'when parameter value is equal to maximum allowed value' do
      it 'returns nil' do
        expect(described_class.new(:foo, :integer, 10, max: 10).apply).to be(nil)
      end
    end

    context 'when parameter value is less than maximum allowed value' do
      it 'returns nil' do
        expect(described_class.new(:foo, :integer, 1, max: 10).apply).to be(nil)
      end
    end
  end
end
