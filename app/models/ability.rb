class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer], author: user
    can :update, Comment, user: user
    can :destroy, Attachment, attachable: { author: user }

    can :mark_best, Answer, question: { author: user }

    can [:up, :down, :unvote], [Question, Answer] do |votable|
      !user.author_of?(votable)
    end
  end
end
