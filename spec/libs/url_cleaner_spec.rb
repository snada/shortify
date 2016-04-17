require 'rails_helper'

RSpec.describe UrlCleaner do
  describe 'clean' do
    it 'should raise exception when input is not a valid uri' do
      expect{ UrlCleaner.clean('a a') }.to raise_exception URI::InvalidURIError
    end

    it 'should append default http protocol if generic uri' do
      expect(UrlCleaner.clean('shopify.com')).to eq('http://shopify.com')
    end
  end
end
