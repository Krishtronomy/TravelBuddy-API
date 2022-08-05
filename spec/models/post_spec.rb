require 'rails_helper'

RSpec.describe Post, type: :model do
before(:all) do
    @test_user = FactoryBot.create(:user, username: "test_user", email: "test@email.com", password: "123456", password_confirmation: "123456")
end


subject {
    described_class.new(

        description: "hi there, im just testing stuff",
        user: @test_user
    )
}

it "is valid with a description attribute" do
    expect(subject).to be_valid
end

it "is not valid with empty description" do
    subject.description = ""
    expect(subject).not_to be_valid
end

it "belongs to a user" do
    subject.user_id = ""
    expect(subject).not_to be_valid
end
end