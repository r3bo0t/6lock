require 'spec_helper'

describe RecordsController do

  def test_successful_response
    expect(response).to be_success
    expect(response.status).to eq(200)
  end

  def test_renders_template(template)
    expect(response).to render_template(template)
  end

  def test_brand_new_folder
    expect(assigns(:folder)).to be_a_new_record
    expect(assigns(:folder)).to be_a_kind_of(Folder)
  end

  def test_brand_new_record
    expect(assigns(:record)).to be_a_new_record
    expect(assigns(:record)).to be_a_kind_of(Record)
  end

  before do
    FactoryGirl.generate(:email)
    @folder1 = FactoryGirl.create(:folder_with_records)
    @folder2 = FactoryGirl.create(:folder_with_records2)
    @user = FactoryGirl.create(:user) do |user|
      user.folders << @folder1 << @folder2
    end
    sign_in @user
    session[:master] = @user.password
  end

  describe "GET #show" do
    context "when the current user owns the record's folder" do
      before do
        @record = @folder1.records.first
        get :show, id: @record.id
      end

      it "responds successfully with an HTTP 200 status code" do
        test_successful_response
      end

      it "renders the show template" do
        test_renders_template('show')
      end

      it "prepares a new folder" do
        test_brand_new_folder
      end

      it "prepares a new record" do
        test_brand_new_record
      end

      it "gets the current user's folders" do
        expect(assigns(:folders)).to include(@folder1, @folder2)
      end

      it "sets the record's folder as the current folder" do
        expect(assigns(:current_folder)).to eq(@record.folder)
      end

      it "sets the current record" do
        expect(assigns(:current_record)).to eq(@record)
      end
    end

    context "when the current user does not own the record's folder" do
      before do
        @record = FactoryGirl.create(:record)
        get :show, id: @record.id
      end

      it "redirects to the home path" do
        expect(response).to redirect_to home_path
      end
    end

    context "when not signed in" do
      before do
        sign_out @user
        get :show, id: @folder1.records.first.id
      end

      it "redirects to the sign in path" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #edit" do
    context "when the current user owns the record's folder" do
      before do
        @record = @folder1.records.first
        get :edit, id: @record.id
      end

      it "responds successfully with an HTTP 200 status code" do
        test_successful_response
      end

      it "renders the edit template" do
        test_renders_template('edit')
      end

      it "prepares a new folder" do
        test_brand_new_folder
      end

      it "prepares a new record" do
        test_brand_new_record
      end

      it "gets the current user's folders" do
        expect(assigns(:folders)).to include(@folder1, @folder2)
      end

      it "sets the record's folder as the current folder" do
        expect(assigns(:current_folder)).to eq(@record.folder)
      end

      it "sets the current record" do
        expect(assigns(:current_record)).to eq(@record)
      end
    end

    context "when the current user does not own the record's folder" do
      before do
        @record = FactoryGirl.create(:record)
        get :edit, id: @record.id
      end

      it "redirects to the home path" do
        expect(response).to redirect_to home_path
      end
    end

    context "when not signed in" do
      before do
        sign_out @user
        get :edit, id: @folder1.records.first.id
      end

      it "redirects to the sign in path" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST #create" do
    context "when the current user owns the folder" do
      before do
        @attrs = FactoryGirl.attributes_for(:record, name: 'new_record', decrypted_password: 'test_password')
        post :create, folder_id: @folder1.id, record: @attrs, format: 'js'
      end

      it "responds successfully with an HTTP 200 status code" do
        test_successful_response
      end

      it "renders the create template" do
        test_renders_template('create')
      end

      it "gets the current user's folders" do
        expect(assigns(:folders)).to include(@folder1, @folder2)
      end

      it "retrieves the right folder" do
        expect(assigns(:folder)).to eq(@folder1)
      end

      it "builds the new record with the right attributes" do
        expect(assigns(:record).name).to eq(@attrs[:name])
      end

      it "saves the new record" do
        expect(assigns(:record)).not_to be_a_new_record
      end

      it "associates the new record with the right folder" do
        expect(assigns(:record).folder).to eq(@folder1)
      end

      it "encrypts the password" do
        expect(assigns(:record).set_decrypted_password(session[:master])).to eq(@attrs[:decrypted_password])
      end
    end

    context "when the current user does not own the folder" do
      before do
        attrs = FactoryGirl.attributes_for(:record, name: 'new_record')
        post :create, folder_id: FactoryGirl.create(:folder).id, record: attrs, format: 'js'
      end

      it "does not render the create template" do
        expect(response).not_to render_template('create')
      end
    end

    context "when not signed in" do
      before do
        sign_out @user
        attrs = FactoryGirl.attributes_for(:record, name: 'new_record')
        post :create, folder_id: @folder1.id, record: attrs, format: 'js'
      end

      it "does not authorize" do
        expect(response.status).to eq(401)
      end
    end
  end

  describe "PUT #update" do
    before { @record = @folder1.records.first }

    context "when the current user owns the folder" do
      context "the record's attributes are valid" do
        before do
          @attrs = FactoryGirl.attributes_for(:record, name: 'new_record', decrypted_password: 'test_password')
          put :update, folder_id: @folder1.id, record: @attrs, id: @record.id, format: 'js'
        end

        context "when the format is js" do
          it "renders the update template" do
            test_renders_template('update')
          end
        end

        context "when the format is html" do
          before { put :update, folder_id: @folder1.id, record: @attrs, id: @record.id }

          it "redirects to the record path" do
            expect(response).to redirect_to record_path(assigns(:record))
          end
        end

        context "when the record needs to be moved to another folder" do
          before { put :update, folder_id: @folder1.id, record: @attrs, current_record: { folder_id: @folder2.id }, id: @record.id }

          it "changes the record's folder" do
            expect(assigns(:record).folder).to eq(@folder2)
          end
        end

        it "responds successfully with an HTTP 200 status code" do
          test_successful_response
        end

        it "gets the current user's folders" do
          expect(assigns(:folders)).to include(@folder1, @folder2)
        end

        it "updates the new record with the right attributes" do
          expect(assigns(:record).name).to eq(@attrs[:name])
        end

        it "saves the new record" do
          expect(assigns(:record)).not_to be_a_new_record
        end

        it "retrieves the new record from the right folder" do
          expect(assigns(:record).folder).to eq(@folder1)
        end

        it "encrypts the password" do
          expect(assigns(:record).set_decrypted_password(session[:master])).to eq(@attrs[:decrypted_password])
        end
      end

      context "when the record's attributes are not valid" do
        before do
          @attrs = FactoryGirl.attributes_for(:record, name: 'a' * 24)
        end

        context "when the format is js" do
          before { put :update, folder_id: @folder1.id, record: @attrs, id: @record.id, format: 'js' }

          it "renders the update template" do
            test_renders_template('update')
          end
        end

        context "when the format is html" do
          before { put :update, folder_id: @folder1.id, record: @attrs, id: @record.id }

          it "redirects to the record path" do
            expect(response).to redirect_to edit_record_path(assigns(:record))
          end

          it "stores the errors in flash" do
            expect(flash[:record_errors]).to eq(assigns(:record).errors)
          end
        end
      end
    end

    context "when the current user does not own the folder" do
      context "when the format is js" do
        before do
          attrs = FactoryGirl.attributes_for(:record, name: 'new_record')
          put :update, folder_id: FactoryGirl.create(:folder).id, record: attrs, id: @record.id, format: 'js'
        end

        it "does not render the update template" do
          expect(response).not_to render_template('update')
        end
      end

      context "when the format is html" do
        before do
          attrs = FactoryGirl.attributes_for(:record, name: 'new_record')
          put :update, folder_id: FactoryGirl.create(:folder).id, id: @record.id, record: attrs
        end

        it "redirects to the home path" do
          expect(response).to redirect_to home_path
        end

        it "sets a flash message" do
          expect(flash[:alert]).to eq("You are not allowed to access this resource.")
        end
      end
    end

    context "when not signed in" do
      before do
        sign_out @user
        attrs = FactoryGirl.attributes_for(:record, name: 'new_record')
        put :update, folder_id: @folder1.id, record: attrs, id: @record.id, format: 'js'
      end

      it "redirects to the sign in path" do
        expect(response.status).to eq(401)
      end
    end

    describe "DELETE #destroy" do
      context "when the current user owns the folder" do
        before do
          @record = @folder1.records.first
          delete :destroy, id: @record.id
        end

        it "gets the current user's folders" do
          expect(assigns(:folders)).to include(@folder1, @folder2)
        end

        it "destroys the record" do
          expect(Record.get_record_from(assigns(:folders), assigns(:record).id)).to be_nil
        end
      end
    end
  end

  describe "GET #delete_favorite" do
    context "when the current user owns the record's folder" do
      before do
        @record = @folder1.records.first
        @record.update_attribute(:position, 1)
        get :delete_favorite, id: @record.id
      end

      it "redirects to the home path" do
        expect(response).to redirect_to home_path
      end

      it "gets the current user's folders" do
        expect(assigns(:folders)).to include(@folder1, @folder2)
      end

      it "sets the current record" do
        expect(assigns(:current_record)).to eq(@record)
      end

      it "removes the current record's position" do
        expect(assigns(:current_record).position).to be_nil
      end
    end

    context "when the current user does not own the record's folder" do
      before do
        @record = FactoryGirl.create(:record)
        get :delete_favorite, id: @record.id
      end

      it "redirects to the home path" do
        expect(response).to redirect_to home_path
      end
    end

    context "when not signed in" do
      before do
        sign_out @user
        get :delete_favorite, id: @folder1.records.first.id
      end

      it "redirects to the sign in path" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end