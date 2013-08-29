########### DAZ4126 website ###########
require "sinatra"
require "slim"
require "sass"
require "redcarpet"
require "pony"
require "thin"
require 'sinatra/reloader' if development?

########### configuration & settings ###########
configure do
  set :name, ENV['NAME'] || 'DAZ4126'
  set :author, ENV['AUTHOR'] || 'DAZ'
  set :analytics, ENV['ANALYTICS'] || 'UA-XXXXXXXX-X'
  set :javascripts, %w[ ]
  set :styles, %w[ main ]
  set :fonts, %w[ Abel ]
  set :markdown, :layout_engine => :slim
  disable :protection
end

helpers do
  def javascripts
    javascripts = ""
    (@javascripts?([@javascripts].flatten+settings.javascripts):settings.javascripts).uniq.each do |script|
      javascripts << "<script src=\"#{script}\"></script>"
    end
    javascripts
  end

  def styles
    styles = ""
    (@styles?([@styles].flatten+settings.styles):settings.styles).uniq.each do |style|
      styles << "<link href=\"/#{style}.css\" media=\"screen, projection\" rel=\"stylesheet\" />"
    end
    styles
  end

  def webfonts
    "<link href=\"http://fonts.googleapis.com/css?family=#{(@fonts?settings.fonts+@fonts:settings.fonts).uniq.*'|'}\" rel=\"stylesheet\" />"
  end
  
  def section(name)
    begin
      slim :section, locals: {name: name}
    rescue
    end
  end
  
end

###########  Routes ###########
not_found { slim :'404' }
error { slim :'500' }
get('/main.css'){ scss :styles }
get('/application.js') { coffee :script }

# home page
get '/' do
  @title = "DAZ, Made in Manchester"
  @banner = "quote#{(rand(3)+1)}"
  slim :index
end

get '/success' do
  @title = "Message Received!"
  slim :success
end

post '/' do
    require 'pony'
    Pony.mail(
      from: "DAZ4126<daz4126@gmail.com>",
      to: 'daz4126@gmail.com',
      subject: "A message from the DAZ4126 website",
      body: params[:message],
      port: '587',
      via: :smtp,
      via_options: { 
        :address              => 'smtp.sendgrid.net', 
        :port                 => '587', 
        :enable_starttls_auto => true, 
        :user_name            => ENV['SENDGRID_USERNAME'], 
        :password             => ENV['SENDGRID_PASSWORD'], 
        :authentication       => :plain, 
        :domain               => 'heroku.com'
      })
    redirect '/success' 
end

get '/:page' do
  if File.exists?('views/'+params[:page]+'.slim')
    slim params[:page].to_sym
  elsif File.exists?('views/'+params[:page]+'.md')
    markdown params[:page].to_sym
  else
    raise error(404) 
  end   
end

__END__
########### Views ###########
@@section
section
  == slim name
  
@@index
== section :about
== section :contact
== section :twitter
== section :websites
== section :writing
== section :github



  
@@about
markdown:
  Alright Mate!
  ==============
  
  Hello from #{rand(10)}
  
  Welcome to my website!

  My name is DAZ and I work, rest and play in Manchester,UK. I build websites, play water polo and eat veggie burgers.

  Thanks for visiting. Have a nice day!
  
@@twitter
h1 Twitter
p Follow me or tweet me <a title="Tweet Me" href="http://twitter.com/#!/daz4126">@daz4126</a>

@@websites
h1 websites
p I like to build websites. Here are some of them:
ul
  li <a href="http://cardsinthecloud.com/">Cards in the Cloud</a>
  li <a href="http://euenergyfocus.co.uk/">EU Energy Focus</a>
  li <a href="http://ididitmyway.heroku.com/">I Did It My Way</a>
  li <a href="http://identity-manchester.heroku.com/">Identity Manchester</a>

@@writing
markdown:
  #Writing
  
  I write articles about Ruby and Sinatra for Rubysource:
  
    * [Fiddling Around With Sinatra part 2](http://rubysource.com/fiddling_around_with_sinatra_ii/)
    *  [Fiddling Around With Sinatra part 1](http://rubysource.com/fiddling-around-with-sinatra/)
    *  [Using Sinatra Helpers to Clean Up Your Code](http://rubysource.com/using-sinatra-helpers-to-clean-up-your-code/)
    *  [Sinatra Up and Running: A Book Review](http://rubysource.com/sinatra-up-and-running-a-book-review/")

@@github
h1 Github
p I love programming and developing web apps. All my stuff is saved on <a href="https://github.com/daz4126">Github</a>.
  
@@quote1
blockquote rel="http://www.flickr.com/photos/nativephotography/4343566244/" We Do Things Differently Here
cite Anthony H Wilson

@@quote2
blockquote rel="http://shop.visitmanchester.com/store/product/2265/Quote-magnet---dark-blue/" They return the love around here, don't they?
cite Guy Garvey

@@quote3
blockquote rel="http://shop.visitmanchester.com/store/product/2265/Quote-magnet---dark-blue/" It All Comes from Here
cite Noel Gallagher

@@contact
#contact
  h2 Contact Me
  form action='/' method='post'
    label for='message' Write me a short message below
    textarea rows='12' cols='40' name='message'
    input#send.button type='submit' value='Send'

@@success
p Thanks for the message. If you included some contact details, I'll be in touch soon.

@@404
h1 404! 
p That page is missing

@@500
h1 500 Error! 
p Oops, something has gone terribly wrong!

@@script
alert 'Coffeescript is working!'
