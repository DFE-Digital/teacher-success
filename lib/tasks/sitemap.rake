desc "Return the URLs of the website"
task sitemap: :environment do
  puts ContentLoader.new.pages.keys.to_json
end
