class PostsController < ApplicationController
    # Set before actions
    before_action :authenticate_user, except: [:index, :show]
    before_action :set_post, only: [:show, :update, :destroy]
    before_action :authorise_user, only: [:update, :destroy]

    # Render all posts stored in the Post Model
    def index
        @posts = Post.all
        render json: @posts
    end

    # Render a specifc post based on a id else render an error
    def show
        if @post
            render json: @post.transform_post
        else
            render json: {"error": "Post not found, wrong id"}, status: :not_found
        end
    end

    # Create a new post using params input by the user, else render a error message
    def create
        @post = current_user.posts.create(post_params)
        if @post.errors.any? 
            render json: @post.errors, status: :unprocessable_entity
        else  
            render json: @post, status: 201
        end 
    end

    # Update an existing post using params input by the user, else render a error message
    def update
        @post.update(post_params)

        if @post.errors.any?
            render json: @post.errors, status: :unprocessable_entity
        else
            render json: @post, status: 201
        end
    end

    # Delete a post using its ID
    def destroy
        @post.delete
        render json: @post, status: 204
    end

    private

#  Define permitted post params
    def post_params
        params.require(:post).permit(:title, :description, :rating, :image)
    end

    # Set post to add to before action
    def set_post
        begin
        @post = Post.find(params[:id])
        rescue
            render json: {error: "Post not found"}, status: 404
        end
    end

    # Add authorisations for creating/updating/deleting posts
    def authorise_user
        if current_user.id != @post.user.id
            render json: {error: "You don't have permission to do that"}, status: 401
        end
    end
end
