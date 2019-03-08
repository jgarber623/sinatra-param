describe Sinatra::Param, :param do
  before do
    mock_app do
      helpers Sinatra::Param

      get '/arguments/invalid/name' do
        param 'foo', :string
      end

      get '/arguments/invalid/type' do
        param :foo, 'string'
      end

      get '/arguments/invalid/unsupported_type' do
        param :foo, :bar
      end
    end
  end

  context 'when given invalid arguments' do
    it 'raises an ArgumentError when name is not a Symbol' do
      message = 'name must be a Symbol (given String)'

      expect { get '/arguments/invalid/name' }.to raise_error(Sinatra::Param::ArgumentError, message)
    end

    it 'raises an ArgumentError when type is not a Symbol' do
      message = 'type must be a Symbol (given String)'

      expect { get '/arguments/invalid/type' }.to raise_error(Sinatra::Param::ArgumentError, message)
    end

    it 'raises an ArgumentError when type is unsupported' do
      message = 'type must be one of [:array, :float, :integer, :string] (given :bar)'

      expect { get '/arguments/invalid/unsupported_type' }.to raise_error(Sinatra::Param::ArgumentError, message)
    end
  end
end
