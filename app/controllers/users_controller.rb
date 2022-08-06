class UsersController < ApplicationController
    # Set before action for update method
    before_action :set_user, only: [:update]

    # Create a new user using params input by the user and set username and token, else render a error message
    def create
        @user = User.create(user_params_create)
        if @user.save
            auth_token = Knock::AuthToken.new payload: {sub: @user.id}
            render json: {username: @user.username, jwt: auth_token.token}, status: :created
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

# Sign in method for authenticating users to ensure details are valid and return json containing user info, else render error message
    def sign_in
        @user = User.find_by_email(params[:email])
        if @user && @user.authenticate(params[:password])
            auth_token = Knock::AuthToken.new payload: {sub: @user.id}
            render json: {id: @user.id, username: @user.username, jwt: auth_token.token, about: @user.about, imageUrl: @user.image_url}, status: 200
        else
            render json: {error: "Incorrect Email or Password"}, status: 404
        end

    end

      # Update an existing users details using params input by the user, else render a error message
    def update
        @user.update(user_params_update)

        if @user.errors.any?
            render json: @user.errors, status: :unprocessable_entity
        else
            render json: @user, status: 201
        end
    end

    # Return a specific user using thier ID
    def get_user
        @user = User.find(params[:id])
        render json: @user, status: 201
    end

    private
#  Define permitted user params for create method
    def user_params_create
        params.permit(:username, :email, :password, :password_confirmation, :image, :id, :about)
    end
#  Define permitted user params for update method (user is required param for update method)
    def user_params_update
        params.require(:user).permit(:username, :email, :password, :password_confirmation, :image, :id, :about)
    end
    
# Set the user using the user ID
    def set_user
        begin
        @user = User.find(params[:id])
        rescue
            render json: {error: "User not found"}, status: 404
        end
    end
end

