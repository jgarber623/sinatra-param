describe Sinatra::Param::Validations::InValidation do
  context 'when given a non-Array in value' do
    it 'raises an ArgumentError' do
      message = 'in must be an Array (given String)'

      expect { described_class.new(:foo, :string, 'bar', in: 'biz') }.to raise_error(Sinatra::Param::ArgumentError, message)
    end
  end

  context 'when given an Array in value' do
    context 'when parameter value is not in specified values' do
      it 'raises an InvalidParameterError' do
        message = 'Parameter foo value "bar" must be in [biz, baz]'

        expect { described_class.new(:foo, :string, 'bar', in: %w[biz baz]).apply }.to raise_error(Sinatra::Param::InvalidParameterError, message)
      end
    end

    context 'when parameter value is in specified values' do
      it 'returns nil' do
        expect(described_class.new(:foo, :string, 'bar', in: %w[bar biz baz]).apply).to be(nil)
      end
    end
  end
end
