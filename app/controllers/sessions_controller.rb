class SessionsController < ApplicationController

  def new
    if current_user
      redirect_to root_path, notice: 'Logged In!'
    end
  end

  def create
    user = User.where(email: params[:email]).first

    if user.present? && user.authenticate(params[:password])
      cookies.signed[:user_id] = user.id
      redirect_to root_path, :notice => 'Logged In!'
    else
      flash.now[:alert] = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    cookies.signed[:user_id] = nil
    redirect_to root_path, :notice => 'Logged Out!'
  end

end
