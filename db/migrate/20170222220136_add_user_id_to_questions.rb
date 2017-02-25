class AddUserIdToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_belongs_to :questions, :author
    add_foreign_key :questions, :users, column: :author_id
  end
end
