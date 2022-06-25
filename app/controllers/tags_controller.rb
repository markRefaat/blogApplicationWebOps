class TagsController < ApplicationController
  before_action :authorize_request
  before_action :set_tag, only: %i[ show update destroy ]

  # GET /tags
  def index
    @tags = Tag.all

    render json: @tags
  end

  # GET /tags/1
  def show
    render json: @tag
  end

  # POST /tags
  def create
    @post = Post.find(tag_params[:post_id])
    if !@current_user.posts.exists?(@post.id)
      render json: {error: "This Post Not Belongs To This User"}, status: :unprocessable_entity
    else
      @tag = Tag.new(tag_params)

      if @tag.save
        render json: @tag, status: :created, location: @tag
      else
        render json: @tag.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /tags/1
  def update
    @post = @tag.post
    if !@current_user.posts.exists?(@post.id)
      render json: {error: "This Post Not Belongs To This User"}, status: :unprocessable_entity
    else
      if @tag.update(tag_params)
        render json: @tag
      else
        render json: @tag.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /tags/1
  def destroy
    @post = @tag.post
    if !@current_user.posts.exists?(@post.id)
      render json: {error: "This Post Not Belongs To This User"}, status: :unprocessable_entity
    else
      @tag.destroy
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tag_params
      params.permit(
        :name, :post_id
      )
      # params.fetch(:tag, {})
    end
end
