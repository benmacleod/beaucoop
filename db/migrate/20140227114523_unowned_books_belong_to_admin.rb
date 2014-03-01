class UnownedBooksBelongToAdmin < ActiveRecord::Migration
  def change
    admin = User.find_by(admin: true)
    if Book.present? and admin
      execute "UPDATE books SET user_id = #{admin.id} WHERE user_id IS NULL"
    end
  end
end
