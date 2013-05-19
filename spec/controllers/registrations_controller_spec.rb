require 'spec_helper'

describe RegistrationsController do

  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "POST #create" do
    before { post :create, user: FactoryGirl.attributes_for(:user) }

    it "responds with an HTTP 302 status code" do
      expect(response.status).to eq(302)
    end

    it "stores the master password in session" do
      expect(session[:master]).to eq(FactoryGirl.attributes_for(:user)[:password])
    end
  end

end