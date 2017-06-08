require 'rails_helper'

shared_examples_for "votable" do
  let(:model) { described_class }
  let(:user) { create(:user, email: "nastya@tut.by") }
  let(:vote) { create(:vote, user: user)}

  # it "can be voted" do
  #   klass = model.to_s.underscore.to_sym
  #   let(:entity) { create(klass, author: user) } if klass eq :question
  #   if klass eq :answer
  #     let(:question) { create(:question, author: user) }
  #     let(:entity) { create(klass, question: question, author: user)}
  #   end
  #   vote = create(:vote, klass: entity, user: user, value: 3)
  #
  # end
end
