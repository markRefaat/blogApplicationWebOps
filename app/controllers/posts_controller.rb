class PostsController < ApplicationController
  before_action :authorize_request
  before_action :set_post, only: %i[ show update destroy ]

  # GET /posts
  def index
    @posts = Post.all.to_json(include: [:comments, :tags,])

    render json: @posts
  end

  # GET /posts/1
  def show
    render json: @post
  end

  # POST /posts
  def create
    if tag_params[:tags] == nil || tag_params[:tags].length() == 0
      render json: {error: "Must Add At Least One Tag" }, status: :unprocessable_entity
    end
    @post = Post.new(post_params)
    tag_params[:tags].each do |tag|
      @post.tags.build({name: tag})
    end
    if @post.save
      DeletePostJob.perform_at(1.minutes.from_now, @post.id)
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if !@current_user.posts.exists?(@post.id)
      render json: {error: "This Post Not Belongs To This User"}, status: :unprocessable_entity
    else
      if @post.update(post_params)
        render json: @post
      else
        render json: @post.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /posts/1
  def destroy
    if !@current_user.posts.exists?(@post.id)
      render json: {error: "This Post Not Belongs To This User"}, status: :unprocessable_entity
    else
      @post.comments.destroy_all
      @post.tags.destroy_all
      @post.destroy
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.permit(
        :title, :body
      ).merge(user_id: @current_user.id)
    end
    def tag_params
      params.permit(:tags => [])
    end
end
