require File.expand_path('../production', __FILE__)

Rails.application.configure do
  p ('-' * 10 ) + 'staging'
end
