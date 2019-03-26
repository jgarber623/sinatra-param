describe Sinatra::Param::Transformation do
  context 'when given an invalid transformation for value' do
    it 'raises an ArgumentError' do
      message = 'transform ":bar" does not exist for value of type String'

      expect { described_class.apply('foo', transform: :bar) }.to raise_error(Sinatra::Param::ArgumentError, message)
    end
  end

  context 'when given an invalid transformation' do
    it 'raises an ArgumentError' do
      message = 'transform must be a Proc or Symbol (given String)'

      expect { described_class.apply('foo', transform: 'bar') }.to raise_error(Sinatra::Param::ArgumentError, message)
    end
  end

  context 'when given a Proc' do
    it 'returns a transformed value' do
      expect(described_class.apply('foo', transform: ->(value) { value.reverse.upcase })).to eq('OOF')
    end
  end

  context 'when given a Symbol' do
    it 'returns a transformed value' do
      expect(described_class.apply('foo', transform: :upcase)).to eq('FOO')
    end
  end
end
