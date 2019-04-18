describe Sinatra::Param do
  class App < Sinatra::Base
    register Sinatra::Param
  end

  class ExceptionsApp < Sinatra::Base
    set :raise_sinatra_param_exceptions, true

    register Sinatra::Param
  end

  describe App do
    it 'registers Sinatra::Param helpers' do
      expect(described_class.included_modules).to include(Sinatra::Param::Helpers)
    end

    it 'configures default exception handling' do
      expect(described_class.raise_sinatra_param_exceptions).to be(false)
    end
  end

  describe ExceptionsApp do
    it 'configures exception handling' do
      expect(described_class.raise_sinatra_param_exceptions).to be(true)
    end
  end
end
