require 'spec_helper'

describe FoldersController do

  before do
    FactoryGirl.generate(:email)
    @folder1 = FactoryGirl.create(:folder)
    @folder2 = FactoryGirl.create(:folder)
    @user = FactoryGirl.create(:user) do |user|
      user.folders << @folder1 << @folder2
    end
    sign_in @user
  end

  describe "POST #create" do
    before { post :create, folder: FactoryGirl.attributes_for(:folder, name: 'new_folder'), format: 'js' }

    it "responds successfully with an HTTP 200 status code" do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the create template" do
      expect(response).to render_template('create')
    end

    it "creates a new folder" do
      expect(assigns(:folder).name).to eq('new_folder')
    end

    it "assigns the new folder to the current user" do
       expect(assigns(:folder).user).to eq(@user)
    end

    it "prepares a new record" do
      expect(assigns(:record)).to be_a_new_record
      expect(assigns(:record)).to be_a_kind_of(Record)
    end
  end

  describe "DELETE #destroy" do
    context "when the folder belongs to the current user" do
      before do
        post :destroy, id: @folder1.id, format: 'js'
      end

      it "responds successfully with an HTTP 200 status code" do
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it "destroys the folder" do
        expect(assigns(:current_user).folders).not_to include(@folder1)
      end
    end

    context "when the folder does not belong to the current user" do
      before do
        @folder3 = FactoryGirl.create(:folder)
        post :destroy, id: @folder3.id, format: 'js'
      end

      it "responds successfully with an HTTP 200 status code" do
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it "does not destroy the folder" do
        expect(Folder.find(@folder3.id)).to eq(@folder3)
      end
    end
  end

  describe "PUT #update" do
    context "when the folder belongs to the current user" do
      before do
        @attrs = FactoryGirl.attributes_for(:folder, name: 'new_name')
        post :update, id: @folder1.id, folder: @attrs, format: 'js'
      end

      it "responds successfully with an HTTP 200 status code" do
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it "renders the update template" do
        expect(response).to render_template('update')
      end

      it "finds the right folder" do
        expect(assigns(:folder)).to eq(@folder1)
      end

      it "updates the folder attributes" do
        expect(assigns(:folder).name).to eq(@attrs[:name])
      end
    end

    context "when the folder does not belong to the current user" do
      before do
        @folder4 = FactoryGirl.create(:folder)
        @attrs = FactoryGirl.attributes_for(:folder, name: 'new_name')
        post :update, id: @folder4.id, folder: @attrs, format: 'js'
      end

      it "responds successfully with an HTTP 200 status code" do
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it "does not render the update template" do
        expect(response).not_to render_template('update')
      end

      it "does not find the folder" do
        expect(assigns(:folder)).to be_nil
      end
    end
  end

end