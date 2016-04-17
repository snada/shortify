require 'rails_helper'

RSpec.describe ShortUrl, type: :model do
  context 'create' do
    it 'fails without a url' do
      expect{ FactoryGirl.create(:short_url, url: nil) }.to raise_exception ActiveRecord::RecordInvalid
      expect{ FactoryGirl.create(:short_url, url: '') }.to raise_exception ActiveRecord::RecordInvalid
    end

    it 'fails when same slug already exist' do
      su = FactoryGirl.create(:short_url)
      expect{ FactoryGirl.create(:short_url, slug: su.slug) }.to raise_exception ActiveRecord::RecordInvalid
    end

    it 'fails with bad url' do
      expect{ FactoryGirl.create(:short_url, url: 'a a') }.to raise_exception ActiveRecord::RecordInvalid
    end

    it 'fails to create same url shortcuts when no slug is given' do
      url = 'https://shopify.com'
      su = FactoryGirl.create(:short_url, url: url, slug: nil)
      expect { FactoryGirl.create(:short_url, url: url, slug: nil) }.to raise_exception ActiveRecord::RecordInvalid
      expect { FactoryGirl.create(:short_url, url: url, slug: '') }.to raise_exception ActiveRecord::RecordInvalid
    end

    it 'fails with generic protocol' do
      expect{ FactoryGirl.create(:short_url, url: 'shopify.com') }.to raise_exception ActiveRecord::RecordInvalid
    end

    it 'fails with unsupported protocol' do
      expect{ FactoryGirl.create(:short_url, url: 'ftp://shopify.com') }.to raise_exception ActiveRecord::RecordInvalid
    end

    it 'succeeds with https protocol' do
      expect{ FactoryGirl.create(:short_url_https) }.not_to raise_exception
    end

    it 'succeeds generating a slug when not passed' do
      expect( FactoryGirl.create(:short_url, slug: nil).slug ).not_to be_nil
      expect( FactoryGirl.create(:short_url, slug: '').slug ).not_to be_nil
    end

    it 'succeeds with same url but different slugs' do
      su = FactoryGirl.create(:short_url, slug: 'slug1', url: 'http://url.com')
      expect{ FactoryGirl.create(:short_url, slug: 'slug2', url: 'http://url.com') }.not_to raise_exception
    end

    it 'generates truncated base62 encoded sha2 digests as slugs' do
      expect {
        su = FactoryGirl.create(:short_url, slug: nil)
        expect(
          Base62.encode62(Digest::SHA2::hexdigest(su.url)).starts_with?(su.slug)
        ).to be_true
      }
      expect {
        su = FactoryGirl.create(:short_url, slug: '')
        expect(
          Base62.encode62(Digest::SHA2::hexdigest(su.url)).starts_with?(su.slug)
        ).to be_true
      }
    end
  end
end
