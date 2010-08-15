class VisitObserver
  include DataMapper::Observer

  observe Visit

  after :create do
    ::TWITTER.status(:post, arrival_tweet)
  end

  after :destroy do
    ::TWITTER.status(:post, departure_tweet)
  end
end

