# frozen_string_literal: true

# Represents a single user, containing a first and last name, and a boolean 
# specifying whether they are an instructor
class User
  attr_reader :id
  attr_accessor :fname, :lname

  def self.all
    users = QuestionsDBConnection.instance.execute('SELECT * FROM users')
    ModelBuilder.u_builder(users)
  end

  def self.find_by_id(id)
    users = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT * FROM users WHERE id = ?
    SQL
    ModelBuilder.u_builder(users)[0]
  end

  def self.find_by_name(fname, lname)
    users = QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
      SELECT * FROM users WHERE fname = ? AND lname = ?
    SQL
    ModelBuilder.u_builder(users)
  end

  def initialize(params)
    @id = params[:id]
    @fname = params[:fname]
    @lname = params[:lname]
    @is_instructor = params[:is_instructor]
  end

  def create
    return self if @id

    QuestionsDBConnection.instance.execute(<<-SQL, @fname, @lname, @is_instructor)
      INSERT INTO users (fname, lname, is_instructor) VALUES (?, ?, ?)
    SQL
  end

  def update
    QuestionsDBConnection.instance.execute(<<-SQL, @fname, @lname, @is_instructor, @id)
      UPDATE users
      SET fname = ?, lname = ?, is_instructor = ?
      WHERE id = ?
    SQL
  end

  def delete
    QuestionsDBConnection.instance.execute(<<-SQL, @id)
      DELETE FROM users WHERE id = ?
    SQL
  end

  def authored_questions
    Question.find_by_user_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def karma
    authored_questions.reduce(0) { |k, q| k += q.num_likes }
  end
end
