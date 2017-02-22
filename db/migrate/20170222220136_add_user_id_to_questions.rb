class AddUserIdToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_belongs_to :questions, :author
  end
end
