class PostsController < ApplicationController
before_action :set_post, only: [:show, :update, :destroy]

    def index
        @posts = Post.all
        render json: @posts
    end

    def show
        if @post
            render json: @post
        else
            render json: {"error": "Post not found, wrong id"}, status: :not_found
        end
    end

    def create
        @post = Post.create(post_params)
        if @post.errors.any? 
            render json: @post.errors, status: :unprocessable_entity
        else  
            render json: @post, status: 201
        end 
    end

    def update
        @post.update(post_params)
    end

    def destroy
        @post.delete
    end

    private


    def post_params
        params.require(:post).permit(:title, :description, :rating)
    end

    def set_post
        begin
        @post = Post.find_by_id(params[:id])
        rescue
            render json: {error: "Post not found"}, status: 404
        end
    end
end
