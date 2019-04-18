describe Sinatra::Param::Helpers, :one_of do
  before do
    mock_app do
      register Sinatra::Param

      before do
        content_type :json
      end

      get '/one_of' do
        param :foo, :string
        param :bar, :string

        one_of :foo, :bar

        json message: 'OK'
      end

      get '/one_of/plaintext' do
        content_type :text

        param :foo, :string
        param :bar, :string

        one_of :foo, :bar

        'OK'
      end

      get '/one_of/raise' do
        param :foo, :string
        param :bar, :string

        one_of :foo, :bar, raise: true
      end
    end
  end

  context 'when more than one parameter is specified' do
    let(:message) { 'Only one of parameters [foo, bar] is allowed' }

    it 'raises a TooManyParametersError' do
      expect { get '/one_of/raise', foo: 1, bar: 2 }.to raise_error(Sinatra::Param::TooManyParametersError, message)
    end

    it 'halts with a 400 HTTP response code and a JSON response body' do
      get '/one_of', foo: 1, bar: 2

      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq({ message: message }.to_json)
    end

    it 'halts with a 400 HTTP response code and a plaintext response body' do
      get '/one_of/plaintext', foo: 1, bar: 2

      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq(message)
    end
  end

  context 'when one parameter is specified' do
    let(:message) { 'OK' }

    it 'returns a 200 HTTP response code and a JSON response body' do
      get '/one_of', foo: 1

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({ message: message }.to_json)
    end

    it 'returns a 200 HTTP response code and a plaintext response body' do
      get '/one_of/plaintext', foo: 1

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(message)
    end
  end
end
