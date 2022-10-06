# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :authenticate_user!
  def index
    render json: current_user
  end
  private

  def user_params
    params.permit(:username, :password)
  end

  def generate_token
    token = encode_token({ user_id: @user.id })
    cookies['AUTH-TOKEN'] = token
    render json: { user: @user }, status: :ok
  end

  def return_unprocessable_entity
    render json: { error: 'Invalid creds.' }, status: :unprocessable_entity
  end
end
