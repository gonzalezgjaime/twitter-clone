class AddNotNullConstraintToTweets < ActiveRecord::Migration[7.2]
  def change
    change_column_null :tweets, :user_id, false
  end
end
