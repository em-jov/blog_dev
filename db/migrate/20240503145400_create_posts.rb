class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :content, null: false
      t.boolean :private, default: true
      t.boolean :draft, default: true

      t.timestamps
    end
  end
end
