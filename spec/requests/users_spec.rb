require 'rails_helper'

RSpec.describe "Users", type: :request do
  before(:all) do
    @test_user = FactoryBot.create(:user, username: "test_user4", email: "test4@email.com", password: "123456", password_confirmation: "123456")
  end

#   Tests signing in with correct details
  describe "POST /sign_in" do
    it "logs in the user with the right credentials" do
      post '/sign_in', params: {email: "test4@email.com", password: "123456"}
      expect(response).to have_http_status(200)
      expect(response.body).to include("test_user4")
    end
#   Tests signing in with incorrect credentials
    it "doesn't log in the user with the wrong credentials" do
      post '/sign_in', params: {email: "test4@email.com", password: "12345"}
      expect(response).to have_http_status(404)
      expect(response.body).to include("Incorrect Email or Password")
    end
#   Tests signing in with incorrect email
    it "doesn't log in the user with the wrong email" do
      post '/sign_in', params: {email: "te@email.com", password: "123456"}
      expect(response).to have_http_status(404)
      expect(response.body).to include("Incorrect Email or Password")
    end

  end
end
