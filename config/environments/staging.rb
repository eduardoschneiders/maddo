require File.expand_path('production', __dir__)

Rails.application.configure do
  p ('-' * 10) + 'staging'
end
