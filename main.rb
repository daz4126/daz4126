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
  set :fonts, %w[ ]

  set :markdown, :layout_engine => :slim

  set :flash, %w[notice error warning alert info]
  enable :sessions
  use Rack::Flash
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
  slim :index
end

get '/success' do
  @title = "Message Received!"
  slim :success
end

get '/:page' do
  markdown params[:page].to_sym
end

post '/' do
    require 'pony'
    Pony.mail(
      from: 'Dazzl',
      to: 'daz4126@gmail.com',
      subject: "A message from the website",
      body: params[:message],
      port: '587',
      via: :smtp,
      via_options: { 
        address: 'smtp.gmail.com', 
        port: '587', 
        enable_starttls_auto: true, 
        user_name: 'daz4126', 
        password: 'senior6DJ!', 
        authentication: :plain, 
        domain: 'localhost.localdomain'
      })
    redirect '/success' 
end

__END__
########### Views ###########

@@index
h1 title='Traditional Mancunian Greeting' Ey Up!

p  Welcome to my website!

p My name is DAZ and I was born and bred in Manchester, UK.

p I enjoy building websites that are simple, but brilliant ... like this one!

p I also like Maths, Water Polo and Beer, although not always at the same time!

p Thanks for visiting, have a nice day!

p
  a.twitter title="Follow Me" href="http://twitter.com/#!/daz4126" @daz4126

@@about
p I love sport - swimming, basketball and especially water polo. I'm a geek at heart and love Maths, programming and web stuff.

@@work
h2 Web Design
p I built this website so that I could write about all that stuff and show off some of my work. I love to build websites that are simple, yet brilliant at the same time. I am a big believer in Open Source. I write about Sinatra web development at <a href='http://rubysource.com'>Ruby Source</a> and <a href='http://ididitmyway.heroku.com'>I Did It My Way</a>.

@@quote
#quote
  .container
    blockquote rel="http://www.flickr.com/photos/nativephotography/4343566244/" We Do Things Differently Here
    cite Anthony H Wilson

@@quote2
#quote
  .container
    blockquote rel="http://shop.visitmanchester.com/store/product/2265/Quote-magnet---dark-blue/" They return the love around here, don't they
    cite Guy Garvey

@@layout
doctype html
html
  head
    meta charset="utf-8"
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
    == slim :quote
    #content role='main'
      .container
        - settings.flash.each do |key|
          - if flash[key]
            div class="alert-message #{key}" == flash[key]
        == yield
    footer role="contentinfo"
      small 
        p &copy; Copyright #{settings.author} #{Time.now.year==2011 ? '2011': '2011-'+Time.now.year.to_s}
        p This site has been lovingly built using <a href="http://xubuntu.org">Xubuntu</a>, <a href="http://ruby-lang.org/en/">Ruby</a>, <a href="http://sinatrarb.com">Sinatra</a> &amp; <a href="http://inkscape.org/">Inkscape</a>. Hosting is provided by <a href="http://heroku.com">Heroku</a>
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

// fonts
$normalfont: "Courier New", "Nimbus Mono L", Monospace;
$headingfont: "Liberation Sans",Helvetica ,Arial, "Nimbus Sans L", FreeSans, Sans-serif;
$basefontsize: 13px;
$thickness:8px;
$width: 61.80%;

@mixin clearfix{_height: 1%;*min-height:1px;zoom:1;
&:after{content:".";display:block;height:0;clear:both;visibility:hidden;}}

@mixin zero{
  margin: 0;
  padding: 0;
}

@mixin grid{
  @include clearfix;
}

@mixin col($width:1,$total:12,$padding:0,$margin:0,$left:0,$right:0){
  float:left;
  margin-left:$margin*1%;
  padding:10px $padding*1%;
  width: $width*100%/$total;
  margin-left:$left*100%/$total;
  margin-right:$right*100%/$total;
}

@mixin headings{
    color:$white;
    font-weight:bold;
    font-family: $headingfont;
    text-transform: uppercase;
    letter-spacing:0.06em;
    line-height:0.8;
    margin: 0 0 0.2em;
}

h1,h2,h3,h4,h5,h6{@include headings;}


a,a:link,a:visited{
  text-decoration: underline;
  color:$red;
}
a:hover{
  background: $red;
  color:$white;
  text-shadow: none;
}

.container{max-width:960px;width:$width;margin:0 auto;padding:20px;}

@media screen and (max-width: 600px) {
  .container {
    width: auto;
  }
}

html{
  background:$grey;
}

body{
  font-family:$normalfont;font-size:$basefontsize;
  border: $thickness solid $border;
}

  p,li{
  color:$text;
  font-size:1.4em;
  line-height:1.1;
  margin: 0.4em 0 0.8em;
  font-weight: bold;
  text-shadow: 1px 1px 0 rgba($white,0.3);
  }

header{
    background: $red;
    border-bottom: $thickness solid $border;  
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
    margin: 10px 0 0;
    text-align: center;
    font-size:1.8em;
    font-weight: normal;
    letter-spacing:0.12em;
  }
  }
}

#quote{
  background: $green;
  border-bottom: $thickness solid $border;

  blockquote{@include headings;font-size:2.2em;}
  
  cite{
        color:$white;
        text-align:right;
        width:100%;
        padding:0;margin:0;
        display:block;
        font-style: italic;
        text-shadow: 1px 1px 0 rgba($white,0.3);
        font-size:1.3em;
} 
}

#content{
  background:$grey;
  border-bottom: $thickness solid $border;
  h1{font-size:4.8em;}
  h2{font-size:3.4em;}
}

footer{
  background: $blue;
  small{@extend .container;font-size:0.9em;display:block;}
  p{color: $white;}
}
