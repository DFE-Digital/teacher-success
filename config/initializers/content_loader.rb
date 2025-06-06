require Rails.root.join('app/services/content_loader')

Rails.application.config.to_prepare do
  CONTENT_LOADER = ContentLoader.new
end
