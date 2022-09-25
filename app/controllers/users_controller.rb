# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    @user = User.create(user_params)

    if @user.valid?
      generate_token
    else
      return_unprocessable_entity
    end
  end

  def login
    @user = User.find_by(username: user_params['username'])

    if @user && @user&.authenticate(user_params['password'])
      generate_token
    else
      return_unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

  def generate_token
    token  = encode_token({ user_id: @user.id })
    render json: { toke: token, user: @user }, status: :ok
  end

  def return_unprocessable_entity
    render json: { error: 'Invalid creds.' }, status: :unprocessable_entity
  end
end
