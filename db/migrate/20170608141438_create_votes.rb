class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.integer :value
      t.references :user
      t.string :votable_type
    end

    add_column :votes, :votable_id, :integer
    add_index :votes, [ :votable_id, :votable_type ]
  end
end
