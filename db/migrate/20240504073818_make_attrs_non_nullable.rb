class MakeAttrsNonNullable < ActiveRecord::Migration[7.1]
  def change
    change_column_null :users, :email, false
    change_column_null :posts, :short_description, false
  end
end
