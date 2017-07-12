class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]
  has_many :questions, foreign_key: :author_id
  has_many :answers, foreign_key: :author_id

  has_many :votes, dependent: :destroy

  has_many :social_networks, dependent: :destroy

  def author_of?(item)
    id == item.author_id
  end

  def self.find_for_oauth(auth)
    social_network = SocialNetwork.where(provider: auth.provider, uid: auth.uid.to_s).first
    return social_network.user if social_network

    email = auth.info[:email]
    user = User.where(email: email).first
    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end
    user.social_networks.create(provider: auth.provider, uid: auth.uid)
    user
  end

end
