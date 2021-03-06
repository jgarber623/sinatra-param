RSpec.describe Sinatra::Param::Validations::MinValidation do
  context 'when given a String parameter type' do
    it 'raises an ArgumentError' do
      message = 'type must be one of [:float, :integer] (given :string)'

      expect { described_class.new(:foo, :string, 'bar', min: 10) }.to raise_error(Sinatra::Param::ArgumentError, message)
    end
  end

  context 'when given a Float parameter type' do
    context 'when given a non-Float min value' do
      it 'raises an ArgumentError' do
        message = 'min must be a Float or an Integer (given String)'

        expect { described_class.new(:foo, :float, 'bar', min: 'biz') }.to raise_error(Sinatra::Param::ArgumentError, message)
      end
    end

    context 'when parameter value is less than minimum allowed value' do
      it 'raises an InvalidParameterError' do
        message = 'Parameter foo value "0.5" must be at least 1.0'

        expect { described_class.new(:foo, :float, 0.5, min: 1.0).apply }.to raise_error(Sinatra::Param::InvalidParameterError, message)
      end
    end

    context 'when parameter value is equal to minimum allowed value' do
      it 'returns nil' do
        expect(described_class.new(:foo, :float, 1.0, min: 1.0).apply).to be(nil)
      end
    end

    context 'when parameter value is greater than minimum allowed value' do
      it 'returns nil' do
        expect(described_class.new(:foo, :float, 1.5, min: 1.0).apply).to be(nil)
      end
    end
  end
end
