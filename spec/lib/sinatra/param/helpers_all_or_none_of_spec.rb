RSpec.describe Sinatra::Param::Helpers, :all_or_none_of do
  before do
    mock_app do
      register Sinatra::Param

      before do
        content_type :json
      end

      get '/all_or_none_of' do
        param :foo, :string
        param :bar, :string
        param :biz, :string

        all_or_none_of :foo, :bar, :biz

        json message: 'OK'
      end

      get '/all_or_none_of/plaintext' do
        content_type :text

        param :foo, :string
        param :bar, :string
        param :biz, :string

        all_or_none_of :foo, :bar, :biz

        'OK'
      end

      get '/all_or_none_of/raise' do
        param :foo, :string
        param :bar, :string
        param :biz, :string

        all_or_none_of :foo, :bar, :biz, raise: true
      end
    end
  end

  context 'when no parameters are specified' do
    let(:message) { 'OK' }

    it 'returns a 200 HTTP response code and a JSON response body' do
      get '/all_or_none_of'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({ message: message }.to_json)
    end

    it 'returns a 200 HTTP response code and a plaintext response body' do
      get '/all_or_none_of/plaintext'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(message)
    end
  end

  context 'when some parameters are specified' do
    let(:message) { 'All or none of parameters [foo, bar, biz] are required' }

    it 'raises a RequiredParameterError' do
      expect { get '/all_or_none_of/raise', foo: 'bar' }.to raise_error(Sinatra::Param::RequiredParameterError, message)
    end

    it 'halts with a 400 HTTP response code and a JSON response body' do
      get '/all_or_none_of', foo: 'bar'

      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq({ message: message }.to_json)
    end

    it 'halts with a 400 HTTP response code and a plaintext response body' do
      get '/all_or_none_of/plaintext', foo: 'bar'

      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq(message)
    end
  end

  context 'when all parameters are specified' do
    let(:message) { 'OK' }

    it 'returns a 200 HTTP response code and a JSON response body' do
      get '/all_or_none_of', foo: 'bar', bar: 'biz', biz: 'baz'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({ message: message }.to_json)
    end

    it 'returns a 200 HTTP response code and a plaintext response body' do
      get '/all_or_none_of/plaintext', foo: 'bar', bar: 'biz', biz: 'baz'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(message)
    end
  end
end
