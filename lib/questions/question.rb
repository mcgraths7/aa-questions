# frozen_string_literal: true

# Represents a single question, associated with a user. Contains a title and
# a body
class Question
  attr_reader :id, :title, :user_id
  attr_accessor :body

  def self.all
    questions = QuestionsDBConnection.instance.execute('SELECT * FROM questions')
    ModelBuilder.q_builder(questions)
  end

  def self.find_by_id(id)
    question = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT * FROM questions WHERE id = ?
    SQL
    ModelBuilder.q_builder(question)
  end

  def self.find_by_user_id(user_id)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT * FROM questions WHERE user_id = ?
    SQL
    ModelBuilder.q_builder(questions)
  end

  def self.most_followed(num)
    QuestionFollow.most_followed_questions(num)
  end

  def self.most_liked(num)
    QuestionLike.most_liked_questions(num)
  end

  def initialize(params)
    @id = params[:id]
    @title = params[:title]
    @body = params[:body]
    @user_id = params[:user_id]
  end

  def create
    return self if @id

    QuestionsDBConnection.instance.execute(<<-SQL, @title, @body, @user_id)
      INSERT INTO questions (title, body, user_id) VALUES (?, ?, ?)
    SQL
  end

  def update
    QuestionsDBConnection.instance.execute(<<-SQL, @body, @id)
      UPDATE questions
      SET body = ?
      WHERE id = ?
    SQL
  end

  def delete
    QuestionsDBConnection.instance.execute(<<-SQL, @id)
      DELETE FROM questions WHERE id = ?
    SQL
  end

  def author
    user = QuestionsDBConnection.instance.execute(<<-SQL, @user_id)
      SELECT * FROM users WHERE id = ?
    SQL
    ModelBuilder.u_builder(user)[0]
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end
end
