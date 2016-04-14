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
      su = FactoryGirl.create(:short_url, slug: 'slug', url: 'url')
      expect{ FactoryGirl.create(:short_url, slug: 'slug') }.to raise_exception ActiveRecord::RecordInvalid
    end

    it 'succeeds with same url but different slugs' do
      su = FactoryGirl.create(:short_url, slug: 'slug1', url: 'url')
      expect{ FactoryGirl.create(:short_url, slug: 'slug2', url: 'url') }.not_to raise_exception
    end
  end
end
