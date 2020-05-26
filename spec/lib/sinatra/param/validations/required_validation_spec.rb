RSpec.describe Sinatra::Param::Validations::RequiredValidation do
  context 'when given a falsy option value' do
    it 'returns nil' do
      expect(described_class.new(:foo, :string, 'bar', required: false).apply).to be(nil)
    end
  end

  context 'when given a truthy option value' do
    context 'when parameter value is nil' do
      it 'raises an InvalidParameterError' do
        message = 'Parameter foo is required and cannot be blank'

        expect { described_class.new(:foo, :string, nil, required: true).apply }.to raise_error(Sinatra::Param::InvalidParameterError, message)
      end
    end

    context 'when parameter value is not nil' do
      it 'returns nil' do
        expect(described_class.new(:foo, :string, 'bar', required: true).apply).to be(nil)
      end
    end
  end
end
