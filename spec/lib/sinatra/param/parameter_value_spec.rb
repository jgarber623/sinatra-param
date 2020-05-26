RSpec.describe Sinatra::Param::Parameter, :value do
  context 'when applying a Default' do
    context 'when no default option is given' do
      it 'sets value to a String' do
        expect(described_class.new(:foo, :string, 'bar').value).to eq('bar')
      end
    end

    context 'when default option is a Proc' do
      it 'sets value to a String' do
        expect(described_class.new(:foo, :string, nil, default: -> { 'bar' }).value).to eq('bar')
      end
    end

    context 'when default option is a String' do
      it 'sets value to a String' do
        expect(described_class.new(:foo, :string, nil, default: 'bar').value).to eq('bar')
      end
    end
  end
end
