# frozen_string_literal: true

# Represents a single reply, associated with a user, question, and optionally
# a reply (if not top level). Contains a body.
class Reply
  attr_accessor :id, :body, :user_id, :question_id, :reply_id

  def self.all
    replies = QuestionsDBConnection.instance.execute('SELECT * FROM replies')
    replies.map do |reply_hash|
      reply_params = { id: reply_hash['id'], body: reply_hash['body'], user_id: reply_hash['user_id'],
                       question_id: reply_hash['question_id'], reply_id: reply_hash['reply_id'] }
      Reply.new(reply_params)
    end
  end

  def self.find_by_user_id(user_id)
    replies = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      select * from replies where user_id = ?
    SQL
    replies.map do |reply_hash|
      reply_params = { id: reply_hash['id'], body: reply_hash['body'], user_id: reply_hash['user_id'],
                       question_id: reply_hash['question_id'], reply_id: reply_hash['reply_id'] || nil }
      Reply.new(reply_params)
    end
  end

  def self.find_by_question_id(question_id)
    replies = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      select * from replies where question_id = ?
    SQL
    replies.map do |reply_hash|
      reply_params = { id: reply_hash['id'], body: reply_hash['body'],
                       user_id: reply_hash['user_id'], question_id: reply_hash['question_id'],
                       reply_id: reply_hash['reply_id'] }
      Reply.new(reply_params)
    end
  end

  def initialize(params)
    @id = params[:id]
    @body = params[:body]
    @user_id = params[:user_id]
    @question_id = params[:question_id]
    @reply_id = params[:reply_id] || nil
  end

  def author
    author = QuestionsDBConnection.instance.execute(<<-SQL, @user_id)
      select * from users where id = ?
    SQL
    is_instructor = author[0]['is_instructor'] == '1'
    author_params = { id: author[0]['id'], fname: author[0]['fname'], lname: author[0]['lname'],
                      is_instructor: is_instructor }
    User.new(author_params)
  end

  def question
    question = QuestionsDBConnection.instance.execute(<<-SQL, @question_id)
      select * from questions where id = ?
    SQL
    question_params = { id: question[0]['id'], title: question[0]['title'],
                        body: question[0]['body'], user_id: question[0]['user_id'] }
    Question.new(question_params)
  end

  def parent_reply
    return unless @reply_id

    reply = QuestionsDBConnection.instance.execute(<<-SQL, @reply_id)
      select * from replies where id = ?
    SQL
    reply_params = { id: reply[0]['id'], body: reply[0]['body'], user_id: reply[0]['user_id'],
                     question_id: reply[0]['question_id'], reply_id: reply[0]['reply_id'] }
    Reply.new(reply_params)
  end

  def child_replies
    replies = QuestionsDBConnection.instance.execute(<<-SQL, @id)
      select * from replies where reply_id = ?
    SQL
    replies.map do |reply_hash|
      reply_params = { id: reply_hash['id'], body: reply_hash['body'], user_id: reply_hash['user_id'],
                       question_id: reply_hash['question_id'], reply_id: reply_hash['reply_id'] }
      Reply.new(reply_params)
    end
  end
end
