Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :google_oauth2, ENV['google_client_id'], ENV['google_client_secret'],
  { scope: 'userinfo.email', prompt: 'consent' }
end
