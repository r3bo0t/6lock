require 'spec_helper'

describe SessionsController do

  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "GET #create" do
    before { post :create, user: FactoryGirl.attributes_for(:user) }

    it "stores the master password in session" do
      expect(session[:master]).to eq(FactoryGirl.attributes_for(:user)[:password])
    end
  end

end