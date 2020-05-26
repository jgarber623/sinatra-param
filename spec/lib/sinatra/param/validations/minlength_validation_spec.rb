RSpec.describe Sinatra::Param::Validations::MinlengthValidation do
  context 'when given a Float parameter type' do
    it 'raises an ArgumentError' do
      message = 'type must be one of [:array, :hash, :string] (given :float)'

      expect { described_class.new(:foo, :float, 1.0, minlength: 10) }.to raise_error(Sinatra::Param::ArgumentError, message)
    end
  end

  context 'when given a non-Integer minlength value' do
    it 'raises an ArgumentError' do
      message = 'minlength must be an Integer (given String)'

      expect { described_class.new(:foo, :string, 'bar', minlength: '10') }.to raise_error(Sinatra::Param::ArgumentError, message)
    end
  end

  context 'when parameter value is shorter than minimum allowed length' do
    it 'raises an InvalidParameterError' do
      message = 'Parameter foo value "bar" length must be at least 4'

      expect { described_class.new(:foo, :string, 'bar', minlength: 4).apply }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end
  end

  context 'when parameter value is equal to minimum allowed length' do
    it 'returns nil' do
      expect(described_class.new(:foo, :string, 'bar', minlength: 3).apply).to be(nil)
    end
  end

  context 'when parameter value is longer than minimum allowed length' do
    it 'returns nil' do
      expect(described_class.new(:foo, :string, 'bar', minlength: 2).apply).to be(nil)
    end
  end
end
