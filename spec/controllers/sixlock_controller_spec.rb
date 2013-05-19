require 'spec_helper'

describe SixlockController do

  describe "responses" do

    def test_successful_response
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    def test_renders_template(template)
      expect(response).to render_template(template)
    end

    describe "GET #who_is_it_for" do
      before { get :who_is_it_for }

      it "responds successfully with an HTTP 200 status code" do
        test_successful_response
      end

      it "renders the right template" do
        test_renders_template('who_is_it_for')
      end
    end

    describe "GET #features" do
      before { get :features }

      it "responds successfully with an HTTP 200 status code" do
        test_successful_response
      end

      it "renders the right template" do
        test_renders_template('features')
      end
    end

    describe "GET #security" do
      before { get :security }

      it "responds successfully with an HTTP 200 status code" do
        test_successful_response
      end

      it "renders the right template" do
        test_renders_template('security')
      end
    end

    describe "GET #user_agreement" do
      before { get :user_agreement }

      it "responds successfully with an HTTP 200 status code" do
        test_successful_response
      end

      it "renders the right template" do
        test_renders_template('user_agreement')
      end
    end

  end

end