require 'rails_helper'

RSpec.describe ShortUrlsController, type: :controller do
  describe 'routing' do
    it 'routes to show' do
      expect(get: '/xyz').to route_to(controller: 'short_urls', action: 'show', slug: 'xyz')
    end

    it 'routes to create' do
      expect(post: '/').to route_to(controller: 'short_urls', action: 'create')
    end

    it 'does not route to index' do
      expect(get: '/').not_to be_routable
    end

    it 'does not route to destroy' do
      expect(delete: '/xyz').not_to be_routable
    end

    it 'does not route to update' do
      expect(patch: '/xyz').not_to be_routable
      expect(put: 'xyz').not_to be_routable
    end
  end

  describe 'GET show' do
    it 'redirects to short_url url' do
      su = FactoryGirl.create(:short_url)
      get :show, slug: su.slug
      expect(response).to redirect_to su.url
    end

    it 'responds with 404 when slug is not found' do
      slug = 'a_fake_slug'
      get :show, slug: slug
      expect(response).to have_http_status(:not_found)
      expect(
        JSON.parse(response.body, symbolize_names: true)
      ).to eq({ errors: [ "Couldn't find a short url with slug #{slug}" ] })
    end
  end

  describe 'POST create' do
    context 'parameters check' do
      it 'fails when url is not present' do
        post :create
        expect(response).to have_http_status(:unprocessable_entity)

        post :create, slug: 'slug'
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'url is bad' do
      it 'should fail with slug' do
        post :create, slug: 'slug', url: 'a  a'
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'should fail without slug' do
        post :create, url: 'a  a'
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'slug is provided' do
      it 'creates a short url with given slug and url' do
        url = 'http://newurl.com'
        slug = 'newslug'
        expect{
          post :create, url: url, slug: slug
        }.to change{ ShortUrl.count }.by(1)

        expect(response).to have_http_status(:success)
        expect(
          JSON.parse(response.body, symbolize_names: true)
        ).to eq({
          url: url,
          short_url: short_url_url( ShortUrl.last.slug )
        })
      end

      it 'does not create a short url if slug is taken and url is different' do
        su = FactoryGirl.create(:short_url)

        expect{
          post :create, url: su.url + '1', slug: su.slug
        }.to change{ ShortUrl.count }.by(0)

        expect(response).to have_http_status(:conflict)
        expect(
          JSON.parse(response.body, symbolize_names: true)
        ).to eq({
          errors: [ "Validation failed: Slug has already been taken" ]
        })
      end
    end

    context 'slug is not provided' do
      it 'creates a short url with given url' do
        url = 'http://lasturl.com'
        expect{
          post :create, url: url
        }.to change{ ShortUrl.count }.by(1)
        expect(
          JSON.parse(response.body, symbolize_names: true)
        ).to eq({
          url: url,
          short_url: short_url_url( ShortUrl.last.slug )
        })
      end

      it 'does not create a shorturl if url is taken' do
        su = FactoryGirl.create(:short_url)
        expect{
          post :create, url: su.url
        }.not_to change{ ShortUrl.count }
        expect(
          JSON.parse(response.body, symbolize_names: true)
        ).to eq({
          url: su.url,
          short_url: short_url_url( ShortUrl.last.slug )
        })
      end
    end
  end
end
