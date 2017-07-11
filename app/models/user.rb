class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]
  has_many :questions, foreign_key: :author_id
  has_many :answers, foreign_key: :author_id

  has_many :votes, dependent: :destroy

  def author_of?(item)
    id == item.author_id
  end
end
