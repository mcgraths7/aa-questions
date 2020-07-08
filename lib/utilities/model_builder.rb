# frozen_string_literal: true

# This class abstracts away the creation of the model, which significantly
# reduces repeating code, as these methods are called in nearly every other class
class ModelBuilder
  def self.q_builder(questions)
    questions.map do |q_hash|
      q_params = {
        id: q_hash['id'],
        title: q_hash['title'],
        body: q_hash['body'],
        user_id: q_hash['user_id'] }
      Question.new(q_params)
    end
  end

  def self.u_builder(users)
    users.map do |u_hash|
      is_instructor = u_hash['is_instructor'] == 1
      u_params = {
        id: u_hash['id'],
        fname: u_hash['fname'],
        lname: u_hash['lname'],
        is_instructor: is_instructor
      }
      User.new(u_params)
    end
  end

  def self.r_builder(replies)
    replies.map do |reply_hash|
      reply_params = {
        id: reply_hash['id'],
        body: reply_hash['body'],
        user_id: reply_hash['user_id'], 
        question_id: reply_hash['question_id'],
        parent_reply_id: reply_hash['parent_reply_id'] 
      }
      Reply.new(reply_params)
    end
  end
end
