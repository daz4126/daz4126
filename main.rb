########### DAZ4126 website ###########
require 'bundler'
Bundler.require

########### configuration & settings ###########
configure do
  set :name, ENV['name'] || 'DAZ4126'
  set :author, ENV['author'] || 'DAZ'
  set :analytics, ENV['ANALYTICS'] || 'UA-XXXXXXXX-X'

  set :javascripts, %w[ ]
  set :fonts, %w[ Abel ]

  set :markdown, :layout_engine => :slim
end


###########  Routes ###########
not_found { slim :'404' }
error { slim :'500' }
get('/styles.css'){ scss :styles }
get('/application.js') { coffee :script }

# home page
get '/' do
  @title = "DAZ, Made in Manchester"
  @before = :quote
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

@@sidebar
ul.sidebar
  li
    h1 Twitter
    p
      a.twitter title="Tweet Me" href="http://twitter.com/#!/daz4126" @daz4126
  li
    h1 Github
  li
    h1 Writing
    p I write articles about Ruby and Sinatra for Rubysources:
    ul
      li An Interview with Konstantin Haase
      li Ruby Heros
      li Ruby Golf
      li Rails or Sinatra? Best of Both Worlds
  li
    h1 websites
    p I like to build websites. Here are some of them:
    ul
      li Cards in the Cloud
      li Identity
      li EU Energy Focus
      li I Did It My Way
  li
    h1 Blog
    p Coming Soon!

@@index
h1 title='Traditional Mancunian Greeting' Alright Mate!

p  Welcome to my website! My name is DAZ and I work, rest and play in Manchester,UK.

p I enjoy building websites that are simple, but brilliant.

p I also like water polo, maths and burgers.

p Thanks for visiting. Have a nice day!

== slim :contact

@@about
p I love sport - swimming, basketball and especially water polo. I'm a geek at heart and love Maths, programming and web stuff.

@@work
h2 Web Design
p I built this website so that I could write about all that stuff and show off some of my work. I love to build websites that are simple, yet brilliant at the same time. I am a big believer in Open Source. I write about Sinatra web development at <a href='http://rubysource.com'>Ruby Source</a> and <a href='http://ididitmyway.heroku.com'>I Did It My Way</a>.

@@quote
#banner
  == slim ('quote'+(rand(3)+1).to_s).to_sym

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

@@404
h1 404! 
p That page is missing

@@500
h1 500 Error! 
p Something has gone wrong!

@@script
alert 'Coffeescript is working!'
