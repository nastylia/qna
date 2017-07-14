class CreateSocialNetworks < ActiveRecord::Migration[5.0]
  def change
    create_table :social_networks do |t|
      t.references :user, foreign_key: true
      t.string :provider
      t.string :uid

      t.timestamps
    end

    add_index :social_networks, [:provider, :uid]
  end
end
