class UsersController < ApplicationController
  layout "application"
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 5, within: 1.hour, only: :create, with: -> { redirect_to new_user_path, alert: "Muitas tentativas. Tente novamente mais tarde." }

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      start_new_session_for @user
      redirect_to after_authentication_url, notice: "Conta criada com sucesso! Bem-vindo ao Sabore!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end
