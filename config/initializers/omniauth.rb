Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production? && ENV["ENABLE_DEVELOPER_AUTH"] != "true"
end
