# frozen_string_literal: true

# This class models a join table between users and questions. A new instance is
# created whenever a user follows a question.
class QuestionFollow
  attr_reader :id, :user_id, :question_id

  def self.followers_for_question_id(question_id)
    users = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT u.* FROM users u JOIN question_follows qf ON qf.user_id = u.id 
      JOIN questions q ON qf.question_id =  q.id WHERE q.id = ?
    SQL
    ModelBuilder.u_builder(users)
  end

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT q.* FROM questions q JOIN question_follows qf ON qf.question_id = q.id
      JOIN users u ON qf.user_id = u.id WHERE u.id = ?
    SQL
    ModelBuilder.q_builder(questions)
  end

  def self.most_followed_questions(num)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, num)
      SELECT q.*, count(*) FROM questions q JOIN question_follows qf ON 
      qf.question_id = q.id GROUP BY qf.question_id LIMIT ?
    SQL
    ModelBuilder.q_builder(questions)
  end

  def initialize(params)
    @id = params[:id]
    @user_id = params[:user_id]
    @question_id = params[:question_id]
  end
end
