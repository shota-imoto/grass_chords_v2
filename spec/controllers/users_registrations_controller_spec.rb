require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @test_user = FactoryBot.create(:user, id: 0, name: "Ralph Stanley")
  end
  describe "registrations#create" do
    it "userレコードを登録できる" do
      user_params = FactoryBot.attributes_for(:user)
      expect{
        post :create, params: {user: user_params}
      }.to change(User, :count).by(1)
    end
  end
  describe "registrations#update" do
    before do
      @user = FactoryBot.create(:user, name: "Earl Scruggs")
      @other_user = FactoryBot.create(:user, name: "J.D. Crowe")
    end
    context "オーナー権を持つユーザーとして" do
      it "userレコードを更新できる" do
        sign_in @user
        user_params = FactoryBot.attributes_for(:user, name: "Noam Pikelny", email: @user.email, current_password: @user.password)
        patch :update, params: {user: user_params}
        expect(@user.reload.name).to eq "Noam Pikelny"
      end
    end
    context "オーナー権を持たないユーザーとして" do
      it "userレコードを更新できない" do
        sign_in @user
        user_params = FactoryBot.attributes_for(:user, name: "Noam Pikelny", email: @other_user.email, current_password: @other_user.password)
        patch :update, params: {user: user_params}
        expect(@other_user.reload.name).to eq "J.D. Crowe"
      end
    end
    context "テストユーザーとして" do
      it "userレコードを更新できない" do
        sign_in @test_user
        user_params = FactoryBot.attributes_for(:user, name: "Noam Pikelny", email: @test_user.email, current_password: @test_user.password)
        patch :update, params: {user: user_params}
        expect(@test_user.reload.name).to eq "Ralph Stanley"
      end
      it "rootにリダイレクトすること" do
        sign_in @test_user
        user_params = FactoryBot.attributes_for(:user, name: "Noam Pikelny")
        patch :update, params: {user: user_params}
        expect(response).to redirect_to root_path
      end
    end
  end
  describe "registrations#destroy" do
    before do
      @user = FactoryBot.create(:user, name: "Earl Scruggs")
      @other_user = FactoryBot.create(:user, name: "J.D. Crowe")
    end
    context "オーナー権を持つユーザーとして" do
      it "userレコードを削除できる" do
        sign_in @user
        expect{
          delete :destroy, params: {id: @user.id}
      }.to change(User, :count).by(-1)
      end
    end
    context "オーナー権を持たないユーザーとして" do
      it "userレコードを削除できない" do
        sign_in @user
        expect{
          delete :destroy, params: {id: @other_user.id}
        }.to change(User.where(id: @other_user.id), :count).by(0)
      end
    end
    context "テストユーザーとして" do
      it "userレコードを削除できない" do
        sign_in @test_user
        expect{
          delete :destroy, params: {id: @test_user.id}
        }.to change(User, :count).by(0)
      end
      it "rootにリダイレクトすること" do
        sign_in @test_user
        delete :destroy, params: {id: @test_user.id}
        expect(response).to redirect_to root_path
      end
    end
    context "ゲストとして" do
      it "userレコードを削除できない" do
        expect{
          delete :destroy, params: {id: @user.id}
        }.to change(User, :count).by(0)
      end
    end
  end
end
