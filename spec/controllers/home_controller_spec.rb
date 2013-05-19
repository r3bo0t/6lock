require 'spec_helper'

describe HomeController do

  before do
    FactoryGirl.generate(:email)
    @folder1 = FactoryGirl.create(:folder_with_records)
    @folder2 = FactoryGirl.create(:folder_with_records2)
    @user = FactoryGirl.create(:user) do |user|
      user.folders << @folder1 << @folder2
    end
    sign_in @user
  end

  describe "GET #index" do
    before { get :index }

    it "responds successfully with an HTTP 200 status code" do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the index template" do
      expect(response).to render_template('index')
    end

    it "prepares a new folder" do
      expect(assigns(:folder)).to be_a_new_record
      expect(assigns(:folder)).to be_a_kind_of(Folder)
    end

    it "prepares a new record" do
      expect(assigns(:record)).to be_a_new_record
      expect(assigns(:record)).to be_a_kind_of(Record)
    end

    it "gets the current user's folders" do
      expect(assigns(:folders)).to include(@folder1, @folder2)
    end

    it "sets the first folder as the current folder" do
      expect(assigns(:current_folder)).to eq(@user.folders.first)
    end

    it "sets the favorite records" do
      expect(assigns(:favorites)).to eq(Record.often_used(assigns(:folders), 'my_password'))
    end
  end

  context "when not signed in" do
    before { sign_out @user }

    describe "GET #index" do
      before { get :index }

      it "redirects to the sign in path" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end