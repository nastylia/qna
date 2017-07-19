require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all}
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create(:question, author: user) }
    let(:other_question) { create(:question, author: other) }
    let(:answer) { create(:answer, author: user, question: question) }
    let(:other_answer) { create(:answer, author: other, question: other_question) }
    let(:file) { create(:attachment, attachable: question) }
    let(:other_file) { create(:attachment, attachable: other_question) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question, user: user }
    it { should_not be_able_to :update, other_question, user: user }

    it { should be_able_to :update, answer, user: user }
    it { should_not be_able_to :update, other_answer, user: user }

    it { should be_able_to :update, create(:my_comment, user: user, commentable: question), user: user }
    it { should_not be_able_to :update, create(:my_comment, user: other, commentable: question), user: user }

    it { should be_able_to :up, other_question, user: user }
    it { should_not be_able_to :up, question, user: user }

    it { should be_able_to :down, other_question, user: user }
    it { should_not be_able_to :down, question, user: user }

    it { should be_able_to :unvote, other_question, user: user }
    it { should_not be_able_to :unvote, question, user: user }

    it { should be_able_to :up, other_answer, user: user }
    it { should_not be_able_to :up, answer, user: user }

    it { should be_able_to :down, other_answer, user: user }
    it { should_not be_able_to :down, answer, user: user }

    it { should be_able_to :unvote, other_answer, user: user }
    it { should_not be_able_to :unvote, answer, user: user }

    it { should be_able_to :destroy, question, user: user }
    it { should_not be_able_to :destroy, other_question, user: user}

    it { should be_able_to :destroy, answer, user: user }
    it { should_not be_able_to :destroy, other_answer, user: user}

    it { should be_able_to :destroy, file, user: user }
    it { should_not be_able_to :destroy, :other_file, user: user }

    it { should be_able_to :mark_best, answer, user: user }
    it { should_not be_able_to :mark_best, other_answer, user: user }

  end

  describe 'API' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }

    it { should be_able_to :me, user: user }
    it { should_not be_able_to :me, user: other }

    it { should be_able_to :all_but_me, user: user }
    it { should be_able_to :all_but_me, user: other }
  end
end
