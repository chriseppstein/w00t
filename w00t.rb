require 'rubygems'
require 'sinatra'
require 'haml'

MOD_TIME = Time.local(1975, 12, 8)

$w00ts_served = 0

get "/" do
  redirect "/w00t"
end

get "/wt" do
  "Don't try to be cute."
end

helpers do
  def font_size
    [((300/(Math.log(@zero_count)/Math.log(2))).round rescue 350), 12].max
  end
end

get %r{/w00t\^(\d+)} do
  @zero_count = params[:captures].first.to_i
  redirect "/wt" if @zero_count == 0
  $w00ts_served +=1 
  if @zero_count < 10000
    @w00t = "w"+("0" * @zero_count)+"t"
    if @zero_count > 10
      @w00t_html = @w00t.gsub(/(.{3})/){|t| "#{t}&shy;"}
    else
      @w00t_html = @w00t
    end
  else
    @js = true
    @w00t_html = @w00t = "w0x#{@zero_count}t"
  end
  @w0t = "w00t^#{@zero_count-1}" unless @zero_count == 1
  @w00t_short_url = @w00t_url = "w00t^#{@zero_count}"
  @w000t = "w00t^#{@zero_count+1}"
  last_modified MOD_TIME
  expires 2592000, :public
  haml :show
end

get %r{/(w0+t)$} do
  $w00ts_served +=1 
  @w00t_url = @w00t = params[:captures].first
  @w0t = "#{@w00t[0..-3]}t"
  @w0t = nil if @w0t == "wt"
  @zero_count = @w00t.size - 2
  if @zero_count > 10
    @w00t_html = @w00t.gsub(/(.{3})/){|t| "#{t}&shy;"}
  else
    @w00t_html = @w00t
  end
  @w000t = "#{@w00t[0..-2]}0t"
  @w00t_short_url = "w00t^#{@zero_count}"
  last_modified MOD_TIME
  expires 2592000, :public
  haml :show
end

get '/stats' do
  $w00ts_served.to_s
end

get '/fonts/*.*' do
  last_modified MOD_TIME
  expires 2592000, :public
  filename = "#{File.dirname(__FILE__)}/views/fonts/#{params[:splat].join(".")}"
  not_found unless File.exists?(filename)
  File.read(filename)
end

get '/favicon.ico' do
  halt 410
end

