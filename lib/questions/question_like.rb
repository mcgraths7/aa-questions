# frozen_string_literal: true

# This class models a join table between users and questions. An new QuestionLike
# is created any time a user likes a question
class QuestionLike
  attr_reader :id, :user_id, :question_id

  def self.likers_for_question_id(question_id)
    users = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT * FROM users u JOIN question_likes ql ON ql.user_id = u.id
      JOIN questions q ON ql_question_id = q.id WHERE q.id = ?
    SQL
    ModelBuilder.u_builder(users)
  end

  def self.num_likes_for_question_id(question_id)
    like_count = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT count(*) c FROM question_likes ql WHERE ql.question_id = ?
    SQL
    like_count[0]['c']
  end

  def self.liked_questions_for_user_id(user_id)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT * FROM questions q JOIN question_likes ql ON ql.question_id = q.id
      JOIN users u ON ql.user_id = u.id WHERE u.id = ?
    SQL
    ModelBuilder.q_builder(questions)
  end

  def self.most_liked_questions(num)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, num)
      SELECT q.*, count(*) FROM questions q JOIN question_likes ql ON 
      ql.question_id = q.id GROUP BY ql.question_id LIMIT ?
    SQL
    ModelBuilder.q_builder(questions)
  end

  def initialize(params)
    @id = params[:id]
    @user_id = params[:user_id]
    @question_id = params[:question_id]
  end
end