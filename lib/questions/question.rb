# frozen_string_literal: true

# Represents a single question, associated with a user. Contains a title and
# a body

# Tasks:
# Question#replies (use Reply::find_by_question_id)
class Question
  attr_accessor :id, :title, :body, :user_id

  def self.all
    questions = QuestionsDBConnection.instance.execute('SELECT * FROM questions')
    questions.map do |question_hash|
      question_params = { id: question_hash['id'], title: question_hash['title'],
                          body: question_hash['body'], user_id: question_hash['user_id'] }
      Question.new(question_params)
    end
  end

  def self.find_by_id(id)
    question_hash = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT * FROM questions WHERE id = ?
    SQL
    question_params = { id: question_hash[0]['id'], title: question_hash[0]['title'],
                        body: question_hash[0]['body'], user_id: question_hash[0]['user_id'] }
    Question.new(question_params)
  end

  def self.find_by_user_id(user_id)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT * FROM questions WHERE user_id = ?
    SQL
    questions.map do |question_hash|
      question_params = { id: question_hash['id'], title: question_hash['title'],
                          body: question_hash['body'], user_id: question_hash['user_id'] }
      Question.new(question_params)
    end
  end

  def initialize(params)
    @id = params[:id]
    @title = params[:title]
    @body = params[:body]
    @user_id = params[:user_id]
  end

  def author
    user_hash = QuestionsDBConnection.instance.execute(<<-SQL, @user_id)
      SELECT * FROM users WHERE id = ?
    SQL
    is_instructor = user_hash[0]['is_instructor'] == '1'
    user_params = { id: user_hash[0]['id'], fname: user_hash[0]['fname'],
                    lname: user_hash[0]['lname'], is_instructor: is_instructor }
    User.new(user_params)
  end

  def replies
    Reply.find_by_question_id(@id)
  end
end
