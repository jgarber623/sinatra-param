RSpec.describe Sinatra::Param::Parameter do
  context 'when name is not a Symbol' do
    it 'raises an ArgumentError' do
      message = 'name must be a Symbol (given String)'

      expect { described_class.new('foo', :string) }.to raise_error(Sinatra::Param::ArgumentError, message)
    end
  end

  context 'when type is not a Symbol' do
    it 'raises an ArgumentError' do
      message = 'type must be a Symbol (given String)'

      expect { described_class.new(:foo, 'string') }.to raise_error(Sinatra::Param::ArgumentError, message)
    end
  end

  context 'when type is not supported' do
    it 'raises an ArgumentError' do
      message = 'type must be one of [:array, :boolean, :float, :hash, :integer, :string] (given :bar)'

      expect { described_class.new(:foo, :bar) }.to raise_error(Sinatra::Param::ArgumentError, message)
    end
  end
end
