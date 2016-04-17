require 'rails_helper'

RSpec.describe ShortUrl, type: :model do
  describe 'scope' do
    context 'shortest_slug' do
      it 'orders by shortest slug' do
        url = 'http://shopify.com'
        FactoryGirl.create(:short_url, url: url, slug: 'very_long_slug')
        FactoryGirl.create(:short_url, url: url, slug: 'short')
        expect(
          ShortUrl.where(url: url).by_shortest_slug.map { |su| su.slug }
        ).to eq(['short', 'very_long_slug'])
      end
    end
  end

  describe 'class method' do
    context 'slug_for' do
      it 'returns shortest slug possible for known urls' do
        su = FactoryGirl.create(:short_url, slug: 'aa')
        FactoryGirl.create(:short_url, url: su.url, slug: 'a')
        expect(ShortUrl.slug_for(su.url)).to eq('a')
      end

      it 'generates truncated base62 encoded sha2 digests as slugs' do
        url = 'http://shopify.com'
        expect(
          Base62.encode62(
            Digest::SHA2::hexdigest(url).to_i(16)
          ).starts_with?(
            ShortUrl.slug_for(url)
          )
        ).to be true
      end

      it 'truncate a longer slug if another one is present' do
        slug = 'L'
        su = FactoryGirl.create(:short_url, slug: slug, url: 'http://asdf.com')
        new_slug = ShortUrl.slug_for('http://shopify.com')

        expect(new_slug.size).to be > slug.size
        expect(new_slug.starts_with?(slug)).to be true
      end
    end
  end

  describe 'create' do
    it 'fails without slug' do
      expect{ FactoryGirl.create(:short_url, slug: nil) }.to raise_exception ActiveRecord::RecordInvalid
      expect{ FactoryGirl.create(:short_url, slug: '') }.to raise_exception ActiveRecord::RecordInvalid
    end

    it 'fails without a url' do
      expect{ FactoryGirl.create(:short_url, url: nil) }.to raise_exception ActiveRecord::RecordInvalid
      expect{ FactoryGirl.create(:short_url, url: '') }.to raise_exception ActiveRecord::RecordInvalid
    end

    it 'succeeds with both url and slug' do
      expect{ FactoryGirl.create(:short_url) }.not_to raise_exception
    end

    it 'fails when slug is taken' do
      su = FactoryGirl.create(:short_url)
      expect{ FactoryGirl.create(:short_url, slug: su.slug) }.to raise_exception ActiveRecord::RecordInvalid
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

    it 'succeeds with same url but different slugs' do
      su = FactoryGirl.create(:short_url, slug: 'slug1', url: 'http://url.com')
      expect{ FactoryGirl.create(:short_url, slug: 'slug2', url: 'http://url.com') }.not_to raise_exception
    end
    
    it 'fails with bad url' do
      expect{ FactoryGirl.create(:short_url, url: 'a a') }.to raise_exception ActiveRecord::RecordInvalid
    end
  end
end
