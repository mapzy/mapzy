# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Redirect to root page if requested content is not authorized
  rescue_from CanCan::AccessDenied do |_exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html do
        redirect_to root_url, notice: 'Oops, it seems like you were on the wrong page.'
      end
    end
  end
end
