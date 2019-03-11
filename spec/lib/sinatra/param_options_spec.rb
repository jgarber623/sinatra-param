describe Sinatra::Param, :param do
  before do
    mock_app do
      helpers Sinatra::Param

      before do
        content_type :json
      end

      get '/default' do
        param :foo, :string, default: 'bar'

        json params
      end

      get '/default/proc' do
        param :foo, :string, default: -> { 'bar' }

        json params
      end
    end
  end

  context 'when parameter has a default' do
    context 'when default is a Proc' do
      it 'returns a 200 HTTP response code and a JSON response body' do
        get '/default/proc'

        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq({ foo: 'bar' }.to_json)
      end
    end

    context 'when default is a String' do
      it 'returns a 200 HTTP response code and a JSON response body when parameter is nil' do
        get '/default'

        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq({ foo: 'bar' }.to_json)
      end

      it 'returns a 200 HTTP response code and a JSON response body when parameter is blank' do
        get '/default', foo: ''

        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq({ foo: 'bar' }.to_json)
      end
    end
  end
end
