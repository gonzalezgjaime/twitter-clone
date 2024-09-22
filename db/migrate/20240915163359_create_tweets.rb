class CreateTweets < ActiveRecord::Migration[7.2]
  def change
    create_table :tweets do |t|
      t.text :body
      t.integer :likes_count
      t.integer :retweets_count

      t.timestamps
    end
  end
end
