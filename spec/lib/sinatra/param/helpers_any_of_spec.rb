describe Sinatra::Param::Helpers, :any_of do
  before do
    mock_app do
      register Sinatra::Param

      before do
        content_type :json
      end

      get '/any_of' do
        param :foo, :string
        param :bar, :string

        any_of :foo, :bar

        json message: 'OK'
      end

      get '/any_of/plaintext' do
        content_type :text

        param :foo, :string
        param :bar, :string

        any_of :foo, :bar

        'OK'
      end

      get '/any_of/raise' do
        param :foo, :string
        param :bar, :string

        any_of :foo, :bar, raise: true
      end
    end
  end

  context 'when no parameters are specified' do
    let(:message) { 'At least one of parameters [foo, bar] is required' }

    it 'raises a RequiredParameterError' do
      expect { get '/any_of/raise' }.to raise_error(Sinatra::Param::RequiredParameterError, message)
    end

    it 'halts with a 400 HTTP response code and a JSON response body' do
      get '/any_of'

      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq({ message: message }.to_json)
    end

    it 'halts with a 400 HTTP response code and a plaintext response body' do
      get '/any_of/plaintext'

      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq(message)
    end
  end

  context 'when one or more parameters are specified' do
    let(:message) { 'OK' }

    it 'returns a 200 HTTP response code and a JSON response body' do
      get '/any_of', foo: 1

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({ message: message }.to_json)
    end

    it 'returns a 200 HTTP response code and a plaintext response body' do
      get '/any_of/plaintext', foo: 1

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(message)
    end
  end
end
