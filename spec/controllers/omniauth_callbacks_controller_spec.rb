require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:callback_params) do
    OpenStruct.new({
      "provider"=> "twitter",
      "uid"     => "1234567890",
      "info"    =>
      OpenStruct.new({
        "nickname"    => "drunk_joe_s",
        "name"        => "Jim Shimoda",
        "email"       => "jshimoda@starfleet.eng.fed",
        "location"    => "1701-D",
        "image"       => "http://example.com/jim.jpg",
        "description" => "Stackin' isolinear chips.",
        "urls"        =>
        OpenStruct.new({
          "Website"   => "http://example.com",
          "Twitter"   => "https://twitter.com/drunk_joe_s"
        })
      })
    })
  end

  before :each do
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = callback_params
  end

  describe "#twitter" do
    context "signing up" do
      before :each do
        post :twitter
      end

      it "creates the user" do
        new_user = User.last&.slice(:uid, :provider)
        expect(new_user).to eq({ "uid" => callback_params.uid, "provider" => callback_params.provider })
      end

      it "creates twitter link" do
        link = User.last.links.twitters.first
        expect(link.url).to eq callback_params.info.urls["Twitter"]
      end

      it "creates website link if there is one" do
        link = User.last.links.websites.first
        expect(link.url).to eq callback_params.info.urls["Website"]
      end
    end

    context "signing in" do
      let!(:user) do
        FactoryGirl.create(:user, provider: "twitter", uid: "1234567890", email: "jshimoda@starfleet.eng.fed")
      end

      it "does not create a new user" do
        expect {
          post :twitter
        }.to_not change { User.count }
      end

      describe "twitter link" do

        before :each do
          request.env["omniauth.auth"].info.urls["Website"] = nil
        end

        it "creates if it's not there already" do
          expect {
            post :twitter
          }.to change { Link.count }.by 1

          expect(User.last.links.twitters.last.url).to eq callback_params.info.urls["Twitter"]
        end

        it "does not create if it already exists" do
          user.links.twitters.create(url: "https://twitter.com/drunk_joe_s");

          expect {
            post :twitter
          }.to_not change { Link.count }
        end
      end

      describe "website link" do
        before :each do
          request.env["omniauth.auth"].info.urls["Twitter"] = nil
        end

        it "creates if list is empty" do
          expect {
            post :twitter
          }.to change { Link.count }.by 1
          expect(User.last.links.websites.last.url).to eq callback_params.info.urls["Website"]
        end

        it "does not create if user has a website link already" do
          user.links.websites.create url: "http://foobar.com"
          expect {
            post :twitter
          }.to_not change { Link.count }
        end

        it "does not create if twitter info doesn't have one" do
          request.env["omniauth.auth"].info.urls["Website"] = nil
          expect {
            post :twitter
          }.to_not change { Link.count }
        end
      end
    end

  end
end