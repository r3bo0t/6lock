require 'spec_helper'

describe SessionsController do

  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "POST #create" do
    before { post :create, user: FactoryGirl.attributes_for(:user) }

    it "responds successfully with an HTTP 200 status code" do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "stores the master password in session" do
      expect(session[:master]).to eq(FactoryGirl.attributes_for(:user)[:password])
    end
  end

end