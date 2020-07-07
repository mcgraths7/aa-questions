require 'byebug'
require './lib/connections/dbconnection'
require './lib/questions/user'
require './lib/questions/question'
require './lib/questions/reply'

qs = Question.all
p q0 = qs[0]
puts '----------------------------------------------------'
p q0.replies
puts '===================================================='
p q1 = qs[1]
puts '----------------------------------------------------'
p q1.replies
puts '===================================================='
p q2 = qs[2]
puts '----------------------------------------------------'
p q2.replies
puts '===================================================='
p q3 = qs[3]
puts '----------------------------------------------------'
p q3.replies
puts '===================================================='



