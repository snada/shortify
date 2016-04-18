class ShortcutsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def show
    begin
      @shortcut = Shortcut.find_by!(slug: params[:slug])
      redirect_to @shortcut.url
    rescue ActiveRecord::RecordNotFound => e
      render_errors([ "Couldn't find a shortcut with slug #{params[:slug]}" ], :not_found)
    end
  end

  def create
    begin
      url = UrlCleaner.clean(shortcut_params[:url])
      slug = shortcut_params[:slug]
      slug = Shortcut.slug_for(url) if slug.blank?

      @shortcut = Shortcut.find_or_create_by!(url: url, slug: slug)

      render json: {
        url: @shortcut.url,
        shortcut: shortcut_url(@shortcut.slug)
      }
    rescue URI::InvalidURIError, ActionController::ParameterMissing => e
      render_errors([ e.message ], :unprocessable_entity)
    rescue ActiveRecord::RecordInvalid => e
      render_errors([ e.message ], :conflict)
    end
  end

  private
    def shortcut_params
      params.require(:url)
      params.permit(:slug, :url)
    end

    def render_errors(errors, status)
      render json: { errors: errors }, status: status
    end
end
