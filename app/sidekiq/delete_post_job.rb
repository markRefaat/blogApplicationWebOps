class DeletePostJob
  include Sidekiq::Job

  def perform(*args)
    @post = Post.find(*args[0])
    if @post != nil
      @post.comments.destroy_all
      @post.tags.destroy_all
      @post.destroy
    end
  end
end
