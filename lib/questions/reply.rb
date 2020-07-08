# frozen_string_literal: true

# Represents a single reply, associated with a user, question, and optionally
# a reply (if not top level). Contains a body.
class Reply
  attr_accessor :id, :body, :user_id, :question_id, :reply_id

  def self.all
    replies = QuestionsDBConnection.instance.execute('SELECT * FROM replies')
    ModelBuilder.r_builder(replies)
  end

  def self.find_by_user_id(user_id)
    replies = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      select * from replies where user_id = ?
    SQL
    ModelBuilder.r_builder(replies)
  end

  def self.find_by_question_id(question_id)
    replies = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      select * from replies where question_id = ?
    SQL
    ModelBuilder.r_builder(replies)
  end

  def initialize(params)
    @id = params[:id]
    @body = params[:body]
    @user_id = params[:user_id]
    @question_id = params[:question_id]
    @parent_reply_id = params[:parent_reply_id] || nil
  end

  def create
    return self if @id

    QuestionsDBConnection.instance.execute(<<-SQL, @body, @user_id, @question_id, @parent_reply_id)
      INSERT INTO replies (body, user_id, question_id, parent_reply_id) VALUES (?, ?, ?, ?)
    SQL
  end

  def update
    QuestionsDBConnection.instance.execute(<<-SQL, @body, @id)
      UPDATE replies
      SET body = ?
      WHERE id = ?
    SQL
  end

  def delete
    QuestionsDBConnection.instance.execute(<<-SQL, @id)
      DELETE FROM replies WHERE id = ?
    SQL
  end

  def author
    user = QuestionsDBConnection.instance.execute(<<-SQL, @user_id)
      select * from users where id = ?
    SQL
    ModelBuilder.u_builder(user)[0]
  end

  def question
    questions = QuestionsDBConnection.instance.execute(<<-SQL, @question_id)
      select * from questions where id = ?
    SQL
    ModelBuilder.q_builder(question)[0]
  end

  def parent_reply
    return unless @parent_reply_id

    reply = QuestionsDBConnection.instance.execute(<<-SQL, @reply_id)
      select * from replies where id = ?
    SQL
    ModelBuilder.r_builder(reply)
  end

  def child_replies
    replies = QuestionsDBConnection.instance.execute(<<-SQL, @id)
      select * from replies where reply_id = ?
    SQL
    ModelBuilder.r_builder(replies)
  end
end
