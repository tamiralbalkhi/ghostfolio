class Api::V1::BaseController < ApplicationController
  # Common functionality for all API controllers can be added here
  protect_from_forgery with: :null_session
  before_action :set_default_response_format

  private

  def set_default_response_format
    request.format = :json
  end
end