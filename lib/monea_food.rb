require 'sinatra/base'
require 'capybara'
require 'capybara/poltergeist'
require 'json'
#require 'sinatra/cross_origin'

class MoneaFood < Sinatra::Base

# configure do
#   enable :cross_origin
# end

before do
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Headers"] = "Origin, X-Requested-With, Content-Type, Accept"
    response.headers["Access-Control-Allow-Methods"] = "*"
    if params[:locale]
      I18n.locale = params[:locale].to_sym 
    end
end

set :protection, false

set :views, File.join(File.dirname(__FILE__), '..', 'views')
set :public_folder, File.join(File.dirname(__FILE__), '..', 'public')
set :partial_template_engine, :erb

# set :allow_origin, :any
# set :allow_methods, [:get]
# set :allow_credentials, true
# set :max_age, "1728000"
# set :expose_headers, ['Content-Type']
# set :allow_headers, ["*", "Content-Type", "Accept", "AUTHORIZATION", "Cache-Control"]

  get '/' do



    content_type :json
    urls = []
      # session = Capybara::Session.new(:selenium) 
      # driver = Selenium::WebDriver.for :chrome
      # 
    content_type :json
    session = Capybara::Session.new(:poltergeist)

    session.driver.headers = { "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.107 Safari/537.36" }
    link = "http://www.bbc.co.uk/news/business/"

    session.visit link
    session.all("a.story").each do |a|
      urls << [a.text, a[:href]]
    end

    {data: urls}.to_json

  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end


