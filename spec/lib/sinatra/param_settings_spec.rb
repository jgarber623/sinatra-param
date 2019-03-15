describe Sinatra::Param, :param do
  before do
    mock_app do
      helpers Sinatra::Param

      configure do
        set :raise_sinatra_param_exceptions, true
      end

      get '/raise' do
        param :foo, :string, required: true
      end
    end
  end

  context 'when raise_sinatra_param_exceptions is true' do
    it 'raises an InvalidParameterError' do
      expect { get '/raise' }.to raise_error(Sinatra::Param::InvalidParameterError, 'Parameter foo is required and cannot be blank')
    end
  end
end
