describe Sinatra::Param, :param do
  before do
    mock_app do
      helpers Sinatra::Param

      before do
        content_type :json
      end

      get '/array' do
        param :foo, :array

        json params
      end

      get '/array/delimiter' do
        param :foo, :array, delimiter: '|'

        json params
      end

      get '/boolean' do
        param :foo, :boolean

        json params
      end

      get '/boolean/raise' do
        param :foo, :boolean, raise: true
      end

      get '/float' do
        param :foo, :float

        json params
      end

      get '/float/raise' do
        param :foo, :float, raise: true
      end

      get '/hash' do
        param :foo, :hash

        json params
      end

      get '/hash/delimiter' do
        param :foo, :hash, delimiter: '|'

        json params
      end

      get '/hash/invalid/options' do
        param :foo, :hash, delimiter: '|', raise: true, separator: '|'
      end

      get '/hash/separator' do
        param :foo, :hash, separator: '|'

        json params
      end

      get '/hash/raise' do
        param :foo, :hash, raise: true
      end

      get '/integer' do
        param :foo, :integer

        json params
      end

      get '/integer/raise' do
        param :foo, :integer, raise: true
      end

      get '/string' do
        param :foo, :string

        json params
      end
    end
  end

  context 'when parameter type is Array' do
    it 'returns a 200 HTTP response code and a JSON response body' do
      get '/array', foo: 'bar,biz,baz'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({ foo: %w[bar biz baz] }.to_json)
    end

    context 'when given foo[]-style parameters' do
      it 'returns a 200 HTTP response code and a JSON response body' do
        get '/array?foo[]=bar&foo[]=biz&foo[]=baz'

        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq({ foo: %w[bar biz baz] }.to_json)
      end
    end

    context 'when given a custom delimiter' do
      it 'returns a 200 HTTP response code and a JSON response body' do
        get '/array/delimiter', foo: 'bar|biz|baz'

        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq({ foo: %w[bar biz baz] }.to_json)
      end
    end
  end

  context 'when parameter type is Boolean' do
    let(:message) { 'Parameter value "bar" must be a Boolean' }
    let(:full_message) { "InvalidParameterError: #{message}" }

    it 'raises an InvalidParameterError' do
      expect { get '/boolean/raise', foo: 'bar' }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end

    it 'halts with a 400 HTTP response code and a JSON response body' do
      get '/boolean', foo: 'bar'

      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq({ message: full_message }.to_json)
    end

    it 'returns a 200 HTTP response code and a JSON response body when given a String' do
      get '/boolean', foo: 'false'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({ foo: false }.to_json)
    end
  end

  context 'when parameter type is Float' do
    let(:message) { 'Parameter value "bar" must be a Float' }
    let(:full_message) { "InvalidParameterError: #{message}" }

    it 'raises an InvalidParameterError' do
      expect { get '/float/raise', foo: 'bar' }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end

    it 'halts with a 400 HTTP response code and a JSON response body' do
      get '/float', foo: 'bar'

      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq({ message: full_message }.to_json)
    end

    it 'returns a 200 HTTP response code and a JSON response body' do
      get '/float', foo: 1.0

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({ foo: 1.0 }.to_json)
    end
  end

  context 'when parameter type is Hash' do
    let(:message) { 'Parameter value "bar" must be a Hash' }
    let(:full_message) { "InvalidParameterError: #{message}" }

    it 'raises an ArgumentError when delimiter and separator are equal' do
      expect { get '/hash/invalid/options', foo: 'bar|bar' }.to raise_error(Sinatra::Param::ArgumentError, 'delimiter and separator cannot be the same')
    end

    it 'raises an InvalidParameterError' do
      expect { get '/hash/raise', foo: 'bar' }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end

    it 'halts with a 400 HTTP response code and a JSON response body' do
      get '/hash', foo: 'bar'

      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq({ message: full_message }.to_json)
    end

    it 'returns a 200 HTTP response code and a JSON response body' do
      get '/hash', foo: 'a:1,b:2,c:3,,,,d:'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({ foo: { a: '1', b: '2', c: '3', d: nil } }.to_json)
    end

    context 'when given a custom delimiter' do
      it 'returns a 200 HTTP response code and a JSON response body' do
        get '/hash/delimiter', foo: 'a:1|b:2|c:3'

        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq({ foo: { a: '1', b: '2', c: '3' } }.to_json)
      end
    end

    context 'when given a custom separator' do
      it 'returns a 200 HTTP response code and a JSON response body' do
        get '/hash/separator', foo: 'a|1,b|2,c|3'

        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq({ foo: { a: '1', b: '2', c: '3' } }.to_json)
      end
    end
  end

  context 'when parameter type is Integer' do
    let(:message) { 'Parameter value "bar" must be an Integer' }
    let(:full_message) { "InvalidParameterError: #{message}" }

    it 'raises an InvalidParameterError' do
      expect { get '/integer/raise', foo: 'bar' }.to raise_error(Sinatra::Param::InvalidParameterError, message)
    end

    it 'halts with a 400 HTTP response code and a JSON response body' do
      get '/integer', foo: 'bar'

      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq({ message: full_message }.to_json)
    end

    it 'returns a 200 HTTP response code and a JSON response body' do
      get '/integer', foo: 1

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({ foo: 1 }.to_json)
    end
  end

  context 'when parameter type is String' do
    it 'returns a 200 HTTP response code and a JSON response body' do
      get '/string', foo: 'bar'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({ foo: 'bar' }.to_json)
    end
  end
end
