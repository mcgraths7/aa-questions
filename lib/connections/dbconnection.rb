# frozen_string_literal: true

require 'sqlite3'
require 'singleton'

# Creates our connection to the database. Initialized as a singleton to prevent
# more than one database connection being created at any time
class QuestionsDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('./db/questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end
