class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    # adds an index to user id and creation date columns
    add_index :microposts, [:user_id, :created_at]
  end
end
