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

      get '/transform' do
        param :foo, :string, transform: :upcase

        json params
      end

      get '/transform/invalid/method' do
        param :foo, :string, raise: true, transform: :bar
      end

      get '/transform/invalid/type' do
        param :foo, :string, raise: true, transform: 'upcase'
      end

      get '/transform/proc' do
        param :foo, :string, transform: ->(p) { p.upcase.reverse }

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

  context 'when parameter has a transform' do
    context 'when transform is an invalid method' do
      it 'raises an ArgumentError' do
        expect { get '/transform/invalid/method', foo: 'bar' }.to raise_error(Sinatra::Param::ArgumentError, 'transform ":bar" does not exist for value of type String')
      end
    end

    context 'when transform is an invalid type' do
      it 'raises an ArgumentError' do
        expect { get '/transform/invalid/type', foo: 'bar' }.to raise_error(Sinatra::Param::ArgumentError, 'transform must be a Proc or Symbol (given String)')
      end
    end

    context 'when transform is a Symbol' do
      it 'returns a 200 HTTP response code and a JSON response body' do
        get '/transform', foo: 'bar'

        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq({ foo: 'BAR' }.to_json)
      end
    end

    context 'when transform is a Proc' do
      it 'returns a 200 HTTP response code and a JSON response body' do
        get '/transform/proc', foo: 'bar'

        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq({ foo: 'RAB' }.to_json)
      end
    end
  end
end