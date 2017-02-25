class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :questions, foreign_key: :author_id
  has_many :answers, foreign_key: :author_id

  def self.author_of?(user, item)
    user && user.id == item.author_id
  end
end
