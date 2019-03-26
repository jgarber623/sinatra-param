describe Sinatra::Param::RequiredValidation do
  context 'when given a falsy option value' do
    it 'returns nil' do
      expect(described_class.apply(:foo, 'bar', :string, required: false)).to be(nil)
    end
  end

  context 'when given a truthy option value' do
    context 'when parameter value is nil' do
      it 'raises an InvalidParameterError' do
        message = 'Parameter foo is required and cannot be blank'

        expect { described_class.apply(:foo, nil, :string, required: true) }.to raise_error(Sinatra::Param::InvalidParameterError, message)
      end
    end

    context 'when parameter value is not nil' do
      it 'returns nil' do
        expect(described_class.apply(:foo, 'bar', :string, required: true)).to be(nil)
      end
    end
  end
end
