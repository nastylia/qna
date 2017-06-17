class AddVotesToQuestionAnswer < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :result_votes, :integer, default: 0
    add_column :answers, :result_votes, :integer, default: 0
  end
end
