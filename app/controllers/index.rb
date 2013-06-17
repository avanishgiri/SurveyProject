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
  all_completed = Completion.all

  @completed = []
  all_completed.each do |completed|
    if completed.user_id == current_user.id
      @completed << Survey.find(completed.survey_id)
    end
  end
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
  if @survey.completions.where("user_id = ?",current_user.id).length == 0
    erb :survey
  else
    erb :survey_results
  end
end

post '/survey/:id' do
  @survey = Survey.find(params[:id])
  responses = []

  if params[:responses].length == @survey.questions.length
    params[:responses].each do |question_id, choice_id|
      responses << Response.create(question_id: question_id, choice_id: choice_id, user_id: current_user.id)
    end
    Completion.create(survey: @survey, user: current_user)
    redirect "/profile/#{current_user.id}"
  else
    @error = "Didn't answer every question."
    erb :survey
  end
end
