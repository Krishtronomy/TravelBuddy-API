require 'rails_helper'

def authenticated_header(user)
    token = Knock::AuthToken.new(payload: {sub: user.id}).token
    { 'Authorization': "Bearer #{token}"}
  end

RSpec.describe "/posts", type: :request do
    before(:all) do
        @test_user2 = FactoryBot.create(:user, username: "test_user2", email: "test2@email.com", password: "123456", password_confirmation: "123456")
        @test_user3 = FactoryBot.create(:user, username: "test_user3", email: "test3@email.com", password: "123456", password_confirmation: "123456")
        FactoryBot.create(:post, title: "Test post 1", description: "Post creation test 1", user: @test_user2)
        FactoryBot.create(:post, title: "Test post 2", description: "Post creation test 2", user: @test_user3)
    end
# tests that all posts are returned when hitting the /posts endpoint
    describe "get all posts from /posts" do
        it "returns all posts" do
            get "/posts"
            print response
            expect(response).to have_http_status(:success)
            expect(JSON.parse(response.body).size).to eq(2)
        end

    end
# tests that the post is returned successfully using the post id
    describe "get posts from /posts/:id" do
        it "returns a post based on the id param" do
            get "/posts/1"
            expect(response).to have_http_status(:success)
            expect(response.body).to include("Post creation test 1")
        end
# tests that the post is not returned if id doesnt exist
        it "returns a not found status based on the wrong id param" do
            get "/posts/17"
            expect(response.body).to include("not found")
        end

    end

#tests creating a post without signing in
    describe 'POST /create' do
        it "doesn't create a new message as its not authorised" do
          post "/create", params: {post: {description: "hello testing, I am unauthorised hehe"}}
          expect(response).to have_http_status(:unauthorized)
        end

#tests creating a post with signing in as a authorised user
        it "creates a new message as its authorised with a user" do
          post "/create", headers: authenticated_header(@test_user2), params: {post: {description: "Hello I have full access"}}
          expect(response).to have_http_status(:created)
          expect(response).to have_http_status(201)
        end
    
    end
#test deleting a post without being authorised
    describe 'DELETE /post/:id' do
        it "doesn't delete a new message as its not authorised" do
          delete "/posts/1"
          expect(response).to have_http_status(:unauthorized)
        end
#test deleting a post as a authorised user
        it "delete the message as its authorised with a user" do
            delete "/posts/1", headers: authenticated_header(@test_user2)
          expect(response).to have_http_status(204)
        end
    
    end
#test updating a post as a authorised user
    describe 'UPDATE /post/:id' do
        it "updates the message as its authorised with a user" do
            put "/posts/1", headers: authenticated_header(@test_user2), params: {post: {description: "Hello I have full access, I can edit this as I please"}}
          expect(response).to have_http_status(201)
        end
    
    end
end