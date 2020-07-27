# frozen_string_literal: true
require "uri"
require "net/http"
require "json"

class Users::SessionsController < Devise::SessionsController
  include UsersHelper
  before_action :test_user_call, only: [:test_create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    # error: before access sessions/create action, automatically sign in even if email & password are correct.
    judge_bot_score = 0.5

    siteverify_uri = URI.parse("https://www.google.com/recaptcha/api/siteverify?response=#{params[:user][:token]}&secret=#{Rails.application.credentials.recaptcha[:recaptcha_secret_key]}")
    response = Net::HTTP.get_response(siteverify_uri)
    json_response = JSON.parse(response.body)

    if json_response["success"] && json_response["score"] > judge_bot_score
      user = User.find_by(email: params[:user][:email])
      if user && user.valid_password?(params[:user][:password])
        respond_to do |format|
          format.js {
            flash[:notice] = "ログインしました"
            render ajax_redirect_to(root_path)
          }
        end
      else
        respond_to do |format|
          format.js {
            flash[:notice] = "メールアドレスもしくはパスワードに誤りがあります"
            render ajax_redirect_to(new_user_session_path)
          }
        end
      end
    else
      # by error, user has already signed in
      # if recaptcha authority is failed, i need user sign out.
      sign_out
      respond_to do |format|
        format.js {
          flash[:notice] = "Googleによって、アクセスが中止されました"
          render ajax_redirect_to(new_user_session_path) }
      end
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def test_create
    sign_in @user
    if current_user
      redirect_to root_path, notice: "お試しログインに成功しました"
    else
      redirect_back fallback_location: :new, notice: "お試しログインに失敗しました：システムエラー：管理者に連絡してください"
    end
  end

  protected

  # def session_params
  #   params.permit(:email, :password)
  # end

  def test_user_call
    @user = User.test_user_find
  end
end
