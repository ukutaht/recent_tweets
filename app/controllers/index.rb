get '/' do
  # Look in app/views/index.erb
  erb :index
end

get '/:username' do
  @user = TwitterUser.find_by_username(params[:username])
  if @user.tweets_stale?
    @user.fetch_tweets!
  end
  
  @tweets = @user.tweets.limit(10)
  
  if request.xhr?
    erb :tweets, layout: false
  else
    "fuck off, we're doing ajax here"
  end
end
