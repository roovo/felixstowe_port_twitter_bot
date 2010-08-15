class VisitObserver
  include DataMapper::Observer

  observe Visit

  after :create do
    ::TWITTER.update(arrival_tweet)
  end

  after :destroy do
    ::TWITTER.update(departure_tweet)
  end
end

