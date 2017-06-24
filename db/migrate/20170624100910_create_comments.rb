class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string :comment
      t.string :commentable_type
      t.references :user
      t.integer :commentable_id
    end

    add_index :comments, [:commentable_id, :commentable_type]
  end
end
