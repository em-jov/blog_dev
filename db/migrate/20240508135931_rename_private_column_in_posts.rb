class RenamePrivateColumnInPosts < ActiveRecord::Migration[7.1]
  def change
    rename_column :posts, :private, :is_private
  end
end
