describe Sinatra::Param do
  describe 'App' do
    before do
      app = Class.new(Sinatra::Base) do
        register Sinatra::Param
      end

      stub_const 'App', app
    end

    it 'registers Sinatra::Param helpers' do
      expect(App.included_modules).to include(Sinatra::Param::Helpers)
    end

    it 'configures default exception handling' do
      expect(App.raise_sinatra_param_exceptions).to be(false)
    end
  end

  describe 'ExceptionsApp' do
    before do
      exceptions_app = Class.new(Sinatra::Base) do
        set :raise_sinatra_param_exceptions, true

        register Sinatra::Param
      end

      stub_const 'ExceptionsApp', exceptions_app
    end

    it 'registers Sinatra::Param helpers' do
      expect(ExceptionsApp.included_modules).to include(Sinatra::Param::Helpers)
    end

    it 'configures exception handling' do
      expect(ExceptionsApp.raise_sinatra_param_exceptions).to be(true)
    end
  end
end
