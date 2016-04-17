require 'net/http'

namespace :stress_test do
  desc "Stress tests the app by generating random urls and creating shortcuts calling the create action. Needs server on. Default is 100 urls."
  task :launch, [:size] => [:environment] do |t, args|
    if Rails.env == 'production'
      puts "This task is unsafe in production." and return
    end

    size = args[:size]
    size ||= 100

    (1..size).each {|n|
      protocol = ['', 'http://', 'https://'].sample
      name = ('a'..'z').to_a.sample(rand(3..15)).join
      tld = ['it', 'com', 'org', 'fr', 'es', 'ca', 'biz', 'gov', 'net', '.us'].sample

      url = "#{protocol}#{name}.#{tld}"

      res = Net::HTTP.post_form(URI('http://localhost:3000'), 'url' => url)
      puts "Request: #{n}, result:#{JSON.parse(res.body)}"
    }
  end
end
