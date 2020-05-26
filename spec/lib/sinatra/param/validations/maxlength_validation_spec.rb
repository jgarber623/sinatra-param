RSpec.describe Sinatra::Param::Validations::MaxlengthValidation do
  context 'when given a Float parameter type' do
    it 'raises an ArgumentError' do
      message = 'type must be one of [:array, :hash, :string] (given :float)'

      expect { described_class.new(:foo, :float, 1.0, maxlength: 10) }.to raise_error(Sinatra::Param::ArgumentError, message)
    end
  end

  context 'when given a non-Integer maxlength value' do
    it 'raises an ArgumentError' do
      message = 'maxlength must be an Integer (given String)'

      expect { described_class.new(:foo, :string, 'bar', maxlength: '10') }.to raise_error(Sinatra::Param::ArgumentError, message)
    end
  end

  context 'when parameter value is longer than maximum allowed length' do
    it 'raises an InvalidParameterError' do
      message = 'Parameter foo value "bar" length must be at most 2'

      expect { described_class.new(:foo, :string, 'bar', maxlength: 2).apply }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end
  end

  context 'when parameter value is equal to maximum allowed length' do
    it 'returns nil' do
      expect(described_class.new(:foo, :string, 'bar', maxlength: 3).apply).to be(nil)
    end
  end

  context 'when parameter value is shorter than maximum allowed length' do
    it 'returns nil' do
      expect(described_class.new(:foo, :string, 'bar', maxlength: 4).apply).to be(nil)
    end
  end
end
