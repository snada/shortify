require 'rails_helper'

RSpec.describe ShortUrl, type: :model do
  context 'create' do
    it 'fails without a url' do
      expect{ FactoryGirl.create(:short_url, url: nil) }.to raise_exception ActiveRecord::RecordInvalid
      expect{ FactoryGirl.create(:short_url, url: '') }.to raise_exception ActiveRecord::RecordInvalid
    end

    it 'fails without a slug' do
      expect{ FactoryGirl.create(:short_url, slug: nil) }.to raise_exception ActiveRecord::RecordInvalid
      expect{ FactoryGirl.create(:short_url, slug: '') }.to raise_exception ActiveRecord::RecordInvalid
    end

    it 'fails when same slug already exist' do
      su = FactoryGirl.create(:short_url, slug: 'slug', url: 'http://url.com')
      expect{ FactoryGirl.create(:short_url, slug: 'slug') }.to raise_exception ActiveRecord::RecordInvalid
    end

    it 'fails with bad url' do
      expect{ FactoryGirl.create(:short_url, url: 'a a') }.to raise_exception ActiveRecord::RecordInvalid
    end

    it 'fails with generic protocol' do
      expect{ FactoryGirl.create(:short_url, url: 'shopify.com') }.to raise_exception ActiveRecord::RecordInvalid
    end

    it 'fails with unsupported protocol' do
      expect{ FactoryGirl.create(:short_url, url: 'ftp://shopify.com') }.to raise_exception ActiveRecord::RecordInvalid
    end

    it 'succeeds with http protocol' do
      expect{ FactoryGirl.create(:short_url, url: 'http://shopify.com') }.not_to raise_exception
    end

    it 'succeeds with https protocol' do
      expect{ FactoryGirl.create(:short_url, url: 'https://shopify.com') }.not_to raise_exception
    end

    it 'succeeds with same url but different slugs' do
      su = FactoryGirl.create(:short_url, slug: 'slug1', url: 'http://url.com')
      expect{ FactoryGirl.create(:short_url, slug: 'slug2', url: 'http://url.com') }.not_to raise_exception
    end
  end
end
