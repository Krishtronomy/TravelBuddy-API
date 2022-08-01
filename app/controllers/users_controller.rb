class UsersController < ApplicationController
    before_action :set_user, only: [:update]

    def create
        @user = User.create(user_params)
        if @user.save
            auth_token = Knock::AuthToken.new payload: {sub: @user.id}
            render json: {username: @user.username, jwt: auth_token.token}, status: :created
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end


    def sign_in
        @user = User.find_by_email(params[:email])
        if @user && @user.authenticate(params[:password])
            auth_token = Knock::AuthToken.new payload: {sub: @user.id}
            render json: {id: @user.id, username: @user.username, jwt: auth_token.token, about: @user.about, imageUrl: @user.image_url}, status: 200
            # render json: {user: @user, jwt: auth_token.token}
        else
            render json: {error: "Incorrect Email or Password"}, status: 404
        end

    end

    def update
        @user.update(user_params)

        if @user.errors.any?
            render json: @user.errors, status: :unprocessable_entity
        else
            render json: @user, status: 201
        end
    end

    def get_user
        @user = User.find(params[:id])
        render json: @user, status: 201
    end

    private

    def user_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation, :image, :id, :about)
    end

    def set_user
        begin
        @user = User.find(params[:id])
        rescue
            render json: {error: "User not found"}, status: 404
        end
    end
end

