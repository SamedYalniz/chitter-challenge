require 'sinatra/base'
require 'sinatra/flash'

ENV['RACK_ENV'] = 'development'

require_relative'data_mapper_setup'

class Chitter < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  get '/'do

  end
  get '/users' do
    erb :'users/new'
  end

  post '/users/new' do
    @user = User.new(email: params[:email],
    password: params[:password],
    password_confirmation: params[:password_confirmation],
    username: params[:username],
    name: params[:name])
    if @user.save
      session[:user_id] = @user.id
      redirect '/users'
    else
      flash[:errors] = @user.errors.full_messages
      redirect '/users'
    end
  end

  get '/sessions' do
    erb :'sessions/new'
  end

  post '/sessions/new' do
    @user = User.authenticate(username: params[:username], password: params[:password])
    if @user
      session[:user_id] = @user.id
      redirect '/users'
    else
      flash.now[:notice] = "password or username incorrect"
      redirect '/sessions'
    end
  end

  helpers do
    def current_user
      @current_user = User.get(session[:user_id])
    end
  end



  # start the server if ruby file executed directly
  run! if app_file == $0
end
