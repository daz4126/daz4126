########### DAZ4126 website ###########
require 'bundler'
Bundler.require

########### configuration & settings ###########
configure do
  set :name, ENV['name'] || 'DAZ4126'
  set :author, ENV['author'] || 'DAZ'
  set :analytics, ENV['ANALYTICS'] || 'UA-XXXXXXXX-X'

  set :public_folder, -> { root }
  set :views, -> { root }

  set :javascripts, %w[ ]
  set :fonts, %w[ Abel ]

  set :markdown, :layout_engine => :slim

  set :flash, %w[notice error warning alert info]
  enable :sessions
  #use Rack::Flash
end

########### Helpers ###########
helpers do
def current?(path='') ; request.path_info=='/'+path ? 'current':  nil ; end

# add your own helpers here ...
end

###########  Filters ###########
before do
  @javascripts = []
  @fonts = []
end

after do
  #after filters go here
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

get '/:page' do
  raise error(404) unless File.exists?(params[:page]+'.md')
  markdown params[:page].to_sym
end

post '/' do
    require 'pony'
    Pony.mail(
      from: "DAZ4126.com",
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

__END__
########### Views ###########

@@index
h1 title='Traditional Mancunian Greeting' Alright Mate!

p  Welcome to my website!

p My name is DAZ and I work, rest and play in Manchester,UK.

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
#quote
  .container
    == slim ('quote'+(rand(3)+1).to_s).to_sym

@@quote1
blockquote rel="http://www.flickr.com/photos/nativephotography/4343566244/" We Do Things Differently Here
cite Anthony H Wilson

@@quote2
blockquote rel="http://shop.visitmanchester.com/store/product/2265/Quote-magnet---dark-blue/" They return the love around here, don't they
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
  h2 Tweet Me 
  p
    a.twitter title="Tweet Me" href="http://twitter.com/#!/daz4126" @daz4126

@@layout
doctype html
html
  head
    meta charset="utf-8"
    meta name="description" content="Made In Manchester by DAZ"
    meta name="author" content="DAZ"
    meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0"
    title= @title || settings.name || "Untitled"
    link rel="shortcut icon" href="/favicon.ico"
    - (settings.javascripts+@javascripts).uniq.each do |link|
      script src==link
    /[if lt IE 9]
      script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"
    link href="http://fonts.googleapis.com/css?family=#{(settings.fonts+@fonts).uniq.*'|'}" rel='stylesheet'
    link rel="stylesheet" media="screen, projection" href="/styles.css"
  body
    header role="banner"
      hgroup
        h1
          a title="Home Sweet Home" href="/" = settings.name
        h2 Made in Manchester
    == slim @before.to_sym if @before
    #main role='main'
      .content
        == yield
    == slim @after.to_sym if @after
    footer role="contentinfo"
      small 
        p &copy; Copyleft #{settings.author} #{Time.now.year==2011 ? '2011': '2011-'+Time.now.year.to_s}
        p This site has been built using <a href="http://xubuntu.org">Xubuntu</a>, <a href="http://ruby-lang.org/en/">Ruby</a>, <a href="http://sinatrarb.com">Sinatra</a> &amp; <a href="http://inkscape.org/">Inkscape</a>. Hosting is provided by <a href="http://heroku.com">Heroku</a>.
      javascript:
        var _gaq=[["_setAccount","#{ settings.analytics }"],["_trackPageview"]];(function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];g.async=g.src="//www.google-analytics.com/ga.js";s.parentNode.insertBefore(g,s)}(document,"script"))

@@404
h1 404! 
p That page is missing

@@500
h1 500 Error! 
p Something has gone wrong!

@@script
alert 'Coffeescript is working!'

@@styles
@import "reset";
@import "colours";
@import "mixins";

// variables

$normalfont: "Courier New", "Nimbus Mono L", Monospace;
$headingfont: Abel,"Liberation Sans",Helvetica ,Arial, "Nimbus Sans L", FreeSans, Sans-serif;
$basefontsize: 13px;
$thickness:8px;
$width: 90%;

// basic elements

html{
  background:$brown url(brown.png) 20px 35px repeat;
}

body{
  font-family:$normalfont;
  font-size:$basefontsize;
  border: $thickness solid $border;
  width: 90%;
  max-width: 840px;
  margin: 10px auto;
  box-shadow: 5px 5px 5px rgba(0,0,0,0.1),-5px 5px 5px rgba(0,0,0,0.1);
}

p,li{
color:$text;
font-size:1.4em;
line-height:1.1;
margin: 0.2em 0 0.8em;
font-weight: bold;
}

h1,h2,h3,h4,h5,h6{@include headings($black);}

h1{font-size:3.2em;}
h2{font-size:2.6em;}
h3{font-size:2em;}

.container{max-width:960px;width:$width;margin:0 auto;}

//responsive layout
@media screen and (max-width: 600px) {
  .container {
    width: auto;
  }
}


header{
    background: $header;
    border-bottom: $thickness solid $border;
    padding:20px;
  hgroup{
    @extend .container;
  h1{
  margin:0;
    a{
      display:block;
      margin:0 auto;
      background:url(/logo.png) transparent 0 0 no-repeat;
      text-indent:-12345px;
      height:120px;width:120px;
      &:hover{  background:url(/logo.png) transparent -120px 0 no-repeat; }
      &:active{ position: relative; top:4px;}
      }
  }
  
  h2{
    color: #fff;
    margin: 10px 0 0;
    text-align: center;
    font-size:1.8em;
    font-weight: normal;
    letter-spacing:0.26em;
  }
  }
}

#quote{
  background: $quote;
  padding: 20px 100px;
  border-bottom: $thickness solid $border;
  blockquote{
    @include headings($quotetext);
    line-height: 0.96;
    font-size:2.6em;
    text-align:center;
  }
  
  cite{
      color:$quotetext;
      padding:0;margin:0;
      font-style: italic;
      font-size:1.3em;
      font-weight: bold;
      display: block;
      text-align: center;
      &:before{content:"★ ";}
      &:after{content:" ★";}
  } 
}

#main{
  .content{@extend .container;}
  background:$main;
  border-bottom: $thickness solid $border;
  padding:20px;
  @include links($black,$black,$yellow);
  p{max-width:26em;text-shadow: 1px 1px 0 rgba($white,0.3);}
  form{
    label{
      display:block;
      color:$text;
      font-size:1.4em;
      font-weight: bold;
    }
    textarea{
      border: $thickness solid $black;
      font-family:$normalfont;
      background: transparent;
      display: block;
      padding: 10px;
      &:focus{outline:none;}
    }
    #send{
      font-family:$normalfont;
      background: $yellow;
      color: $black;
      border: none;
      color:$text;
      font-size:1.4em;
      padding: 0.6em 0.5em;
      font-weight: bold;
    }
  }
}

footer{
  background:$footer;
  padding:20px;
  #contact{@extend .container;}
  small{@extend .container;font-size:0.85em;display:block;}
  p{color: $white;}
  @include links($yellow,$black);
}
