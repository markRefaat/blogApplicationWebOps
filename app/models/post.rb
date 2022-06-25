class Post < ApplicationRecord
    has_many :comments
    has_many :tags
    belongs_to :user, optional: true
end
