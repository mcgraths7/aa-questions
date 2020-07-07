# frozen_string_literal: true

# Represents a single user, containing a first and last name

# Tasks:
class User
  attr_accessor :id, :fname, :lname

  def self.all
    users = QuestionsDBConnection.instance.execute('SELECT * FROM users')
    users.map do |user_hash|
      user_params = { id: user_hash['id'], fname: user_hash['fname'],
                      lname: user_hash['lname'], is_instructor: user_hash['is_instructor'] }
      User.new(user_params)
    end
  end

  def self.find_by_id(id)
    raise 'Must specify a valid numerical id' unless id.is_a? Integer

    user_hash = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT * FROM users WHERE id = ?
    SQL
    is_instructor = user_hash[0]['is_instructor'] == '1'
    user_params = { id: user_hash[0]['id'], fname: user_hash[0]['fname'],
                    lname: user_hash[0]['lname'], is_instructor: is_instructor }
    User.new(user_params)
  end

  def self.find_by_name(fname, lname)
    raise ArgumentError, 'Must specify a valid first and last name' if fname.empty? || lname.empty?

    users = QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
      SELECT * FROM users WHERE fname = ? AND lname = ?
    SQL

    users.map do |user_hash|
      is_instructor = user_hash['is_instructor'] == 1
      user_params = { id: user_hash['id'], fname: user_hash['fname'],
                      lname: user_hash['lname'], is_instructor: is_instructor }
      User.new(user_params)
    end
  end

  def initialize(params)
    @id = params[:id]
    @fname = params[:fname]
    @lname = params[:lname]
    @is_instructor = params[:is_instructor]
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end
end
