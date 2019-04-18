describe Sinatra::Param::Helpers, :param do
  before do
    mock_app do
      register Sinatra::Param

      before { content_type :json }

      get '/message' do
        content_type :text

        param :foo, :string, message: 'bar', required: true
      end

      get '/message/raise' do
        param :foo, :string, message: 'bar', raise: true, required: true
      end

      get '/optional' do
        param :foo, :string

        json params
      end

      get '/required' do
        param :foo, :string, required: true

        json params
      end

      get '/required/default' do
        param :foo, :string, default: 'bar', required: true

        json params
      end

      get '/required/raise' do
        param :foo, :string, raise: true, required: true
      end

      get '/validations/raise' do
        param :foo, required: true, format: %r{^https?://}, raise: true
      end
    end
  end

  context 'when optional parameter is not present' do
    it 'returns a 200 HTTP response code and a JSON response body' do
      get '/optional', bar: 'biz'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({ bar: 'biz' }.to_json)
    end
  end

  context 'when required parameter is not present' do
    it 'raises an InvalidParameterError' do
      message = 'Parameter foo is required and cannot be blank'

      expect { get '/required/raise' }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end

    it 'returns a 400 HTTP response code and a JSON response body' do
      get '/required'

      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq({ message: 'Parameter foo is required and cannot be blank' }.to_json)
    end

    context 'when default is provided' do
      it 'returns a 200 HTTP response code and a JSON response body' do
        get '/required/default'

        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq({ foo: 'bar' }.to_json)
      end
    end
  end

  context 'when required parameter is present' do
    it 'returns a 200 HTTP response code and a JSON response body' do
      get '/required', foo: 'bar'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({ foo: 'bar' }.to_json)
    end
  end

  context 'when setting a custom exception message' do
    it 'raises an InvalidParameterError' do
      expect { get '/message/raise' }.to raise_error(Sinatra::Param::InvalidParameterError, 'bar')
    end

    it 'halts with a 400 HTTP response code and a plaintext response body' do
      get '/message'

      expect(last_response.body).to eq('bar')
    end
  end

  context 'when mixing validations' do
    it 'raises an InvalidParameterError' do
      message = 'Parameter foo is required and cannot be blank'

      expect { get '/validations/raise' }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end
  end
end
