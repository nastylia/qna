class AddUserIdToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_belongs_to :answers, :author
    add_foreign_key :answers, :users, column: :author_id
  end
end
