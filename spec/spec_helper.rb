begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

begin
  require 'ruby-debug'
rescue LoadError
  require 'rubygems'
  gem 'ruby-debug'
  require 'ruby-debug'
end
require 'dm-core'
require 'dm-validations'
require 'dm-aggregates'
require 'dm-audited'

$LOAD_PATH  << File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH  << File.expand_path(File.dirname(__FILE__) + '/../lib/models')

require 'visit.rb'

database_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'db', 'test.db'))
DataMapper.setup(:default, "sqlite3://#{database_path}")

Visit.auto_migrate!
DataMapper::Audited::Audit.auto_migrate!

Spec::Runner.configure do |config|
  config.after(:each) do
    repository(:default) do
      while repository.adapter.current_transaction
        repository.adapter.current_transaction.rollback
        repository.adapter.pop_transaction
      end
    end
  end
  config.before(:each) do
    repository(:default) do
      transaction = DataMapper::Transaction.new(repository)
      transaction.begin
      repository.adapter.push_transaction(transaction)
    end
  end
end
