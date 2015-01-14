APP_ENV = ENV["APP_ENV"] || "development"
require "bundler/setup"
require "json"
require "roda"
require "sqlite3"
require "sequel"

db_env = ENV["RACK_ENV"] || "development"
DB = Sequel.sqlite("db/#{db_env}.sqlite3")
