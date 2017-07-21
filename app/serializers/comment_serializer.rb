class CommentSerializer < ActiveModel::Serializer
  attributes :id, :comment, :user_id, :commentable_type, :commentable_id
end
