# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def mapzy_cloud?
    ENV["MAPZY_CLOUD"] == "true"
  end

  # simple implementation based on rails docs: https://guides.rubyonrails.org/i18n.html#inferring-locale-from-the-language-header
  def switch_locale(&action)
    # if there's a locally in the embed params, use that, otherwise, use the language header

    locale = params[:language] || extract_locale_from_accept_language_header

    # fall back to english if the set locale is not available
    locale = :en unless I18n.available_locales.include?(locale&.to_sym)
    I18n.with_locale(locale, &action)
  end

  private

  def extract_locale_from_accept_language_header
    request.env["HTTP_ACCEPT_LANGUAGE"]&.scan(/^[a-z]{2}/)&.first
  end
end
