class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :replies, class_name: "Comment", foreign_key: :original_comment_id, dependent: :destroy
  belongs_to :original_comment, class_name: "Comment", optional: true

  #check if this comment is a reply to another comment, if true increment the original comments replies count. 
  #Then increment the number of comments count for the post that the particular comment belongs to. 
  after_create do 
    if self.original_comment_id 
      original_comment = Comment.find(self.original_comment_id)
      original_comment.replies_count += 1 
      original_comment.save
    end
    post = Post.find(self.post_id)
    #every time a comment is created, the post underwhich that comment belongs to has its number_of_replies count incremented.
    post.number_of_comments += 1
  end

end
