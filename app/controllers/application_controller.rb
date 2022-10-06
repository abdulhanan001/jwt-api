# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Cookies
  attr_reader :current_user

  def encode_token(payload)
    JWT.encode(payload, 'secret')
  end

  def authenticate_user!
    token = cookies['AUTH-TOKEN']
    decoded_token = JWT.decode(token, 'secret')

    @current_user = User.find_by(id: decoded_token[0]['user_id'])
  rescue JWT::DecodeError
    render json: { message: 'Invalid authentication token!' }, status: :unprocessable_entity
  end
end
