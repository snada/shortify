class ShortUrlsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def show
    begin
      @short_url = ShortUrl.find_by!(slug: params[:slug])
      redirect_to @short_url.url
    rescue ActiveRecord::RecordNotFound => e
      render_errors([ "Couldn't find a short url with slug #{params[:slug]}" ], :not_found)
    end
  end

  def create
    begin
      url = UrlCleaner.clean(short_url_params[:url])
      slug = short_url_params[:slug]
      slug ||= ShortUrl.slug_for(url)

      @short_url = ShortUrl.find_or_create_by!(url: url, slug: slug)

      render json: {
        url: @short_url.url,
        short_url: short_url_url(@short_url.slug)
      }
    rescue URI::InvalidURIError, ActionController::ParameterMissing => e
      render_errors([ e.message ], :unprocessable_entity)
    rescue ActiveRecord::RecordInvalid => e
      render_errors([ e.message ], :conflict)
    end
  end

  private
    def short_url_params
      params.require(:url)
      params.permit(:slug, :url)
    end

    def render_errors(errors, status)
      render json: { errors: errors }, status: status
    end
end
