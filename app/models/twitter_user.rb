class TwitterUser < ActiveRecord::Base
  has_many :tweets

  def self.find_by_username(username)
    user_from_twitter = Twitter.user(username)

    TwitterUser.where(username: user_from_twitter.username,
                      name: user_from_twitter.name,
                      location: user_from_twitter.location,
                      description: user_from_twitter.description,
                      user_created_at: user_from_twitter.created_at).first_or_create
  end
  
  def fetch_tweets!
    tweet_array = Twitter.user_timeline(self.username)

    
    self.tweets = tweet_array.map do |tweet|
      Tweet.create(text: tweet.text, tweet_created_at: tweet.created_at)
    end 
  end


  def tweets_stale?
    
    unless tweets.empty?
      return time_since_update >= 900
    else
      true
    end
  
  end

  def time_since_update
    Time.now - self.tweets.first.created_at
  end
end

