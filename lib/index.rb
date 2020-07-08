# frozen_string_literal: true

# The index file loads all required classes and acts as a single point of truth
# for loading in files.

require './lib/connections/dbconnection'
require './lib/questions/user'
require './lib/questions/question'
require './lib/questions/reply'
require './lib/questions/question_follow'
require './lib/questions/question_like'
require './lib/utilities/model_builder.rb'