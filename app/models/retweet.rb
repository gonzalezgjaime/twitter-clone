class Retweet < ApplicationRecord
  belongs_to :user
  belongs_to :tweet

  # validates :tweet_id, uniqueness: { scope: :tweet_id, message: "Already tweeted" }
end
