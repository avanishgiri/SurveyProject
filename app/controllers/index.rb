get '/' do
  erb :index
end

post '/users/new' do
  user = User.create(params[:user])
  if user
    session[:user_id] = user.id
    redirect "/profile/#{user.id}"
  else
    redirect '/'
  end
end

post '/login' do
  p params
  user = User.find_by_email(params[:user][:email])
  if user.check_password(params[:user][:password])
    session[:user_id] = user.id
    redirect "/profile/#{user.id}"
  else
    erb :index
  end
end

get '/profile/:id' do
  p params
  redirect '/' unless current_user
  @surveys = Survey.all
  erb :profile
end

get '/logout' do
  session.clear
  redirect '/'
end

get '/survey/new' do
  erb :create_survey_alt
end

post '/survey/new' do
  p params
  survey_id = Survey.create(title: params[:topic]).id
  params[:questions].each do |key, value|
    q = Question.create(question_text: value[:question_text], survey_id: survey_id)
    value[:answers].each { |string| Choice.create(choice_text: string, question_id: q.id) }
  end
  redirect "/profile/#{current_user.id}"
end

get '/survey/:survey_id' do |survey_id|
  @survey = Survey.find(survey_id)
  erb :survey
end

post '/survey/:id' do
  p params
end

get '/test/*/*' do
  p params
end

