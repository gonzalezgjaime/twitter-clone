class Tweet < ApplicationRecord
  validates :body, presence: true

  belongs_to :user
  has_many :retweets, dependent: :destroy

  def retweet_count
    retweets.count
  end
end
