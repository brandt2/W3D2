require 'sqlite3'
require 'singleton'
require 'byebug'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

#-------------------------------------------------------------------------------
class Users
	attr_accessor :fname, :lname
	attr_reader :id

	def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM users")
    data.map { |datum| Users.new(datum) }
	end
	
	def self.find_by_id(id)
		user = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    return nil unless user.length > 0

    Users.new(user.first)
	end

	def self.find_by_name(fname, lname)
		user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
    return nil unless user.length > 0

    Users.new(user.first)
	end

	def authored_questions
		# question = Questions.find_by_author_id(id)
		questions = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
				questions
      WHERE
        author_id = ?
    SQL
    return nil unless questions.length > 0

		questions.map do |options|
			Questions.new(options)
		end
	end

	def authored_replies
		reply_name = Reply.find_by_writer_id(id)
		user = QuestionsDatabase.instance.execute(<<-SQL, reply_name.id)
      SELECT
        *
      FROM
				users
      WHERE
        id = ?
    SQL
    return nil unless user.length > 0

    Users.new(user.first)
	end

	def initialize(options)
		@id = options['id']
		@fname = options['fname']
		@lname = options['lname']
	end 	
end 
#-------------------------------------------------------------------------------

class Questions
	attr_accessor :title, :body, :author_id
	attr_reader :id

	def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    data.map { |datum| Questions.new(datum) }
	end
	
	def self.find_by_id(id)
		question = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    return nil unless question.length > 0

    Questions.new(question.first)
	end

	def find_by_author_id
		question = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL
    return nil unless question.length > 0
    Questions.new(question.first)
	end

	def author
		question = QuestionsDatabase.instance.execute(<<-SQL, author_id)
			SELECT
				users.fname, users.lname, users.id
			FROM
				users
			JOIN
				questions ON users.id = questions.author_id
			WHERE
				author_id = ?
		SQL
		return nil unless question.length > 0
    Users.new(question.first)
	end

	def replies
		data = QuestionsDatabase.instance.execute(<<-SQL, id)
			SELECT
				*
			FROM
				questions
			WHERE
				id = ?
		SQL
		data.map { |datum| Questions.new(datum)}
	end
	
	def initialize(options)
		@id = options['id']
		@title = options['title']
		@body = options['body']
		@author_id = options['author_id']
	end 	
end 

#-------------------------------------------------------------------------------

class Reply
	attr_accessor :subject_question_id, :parent_reply_id, :writer_id, :reply_body
	attr_reader :id
	
	def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    data.map { |datum| Reply.new(datum) }
	end
	
	def self.find_by_id(id)
		reply = QuestionsDatabase.instance.execute(<<-SQL, id)
			SELECT
				*
			FROM
				replies
			WHERE
				id = ?
    SQL
    return nil unless reply.length > 0
		
    Reply.new(reply.first)
	end

	def self.find_by_writer_id(writer_id)
		reply = QuestionsDatabase.instance.execute(<<-SQL, writer_id)
			SELECT
				*
			FROM
				replies
			WHERE
				writer_id = ?
			SQL
    return nil unless reply.length > 0
		
    Reply.new(reply.first)
	end

	def self.find_by_subject_question_id(subject_question_id)
		reply = QuestionsDatabase.instance.execute(<<-SQL, subject_question_id)
			SELECT
				*
			FROM
				replies
			WHERE
				subject_question_id = ?
			SQL
    return nil unless reply.length > 0
		
    Reply.new(reply.first)
	end
	
	def initialize(options)
		@id = options['id']
		@subject_question_id = options['subject_question_id']
		@parent_reply_id = options['parent_reply_id']
		@writer_id = options['writer_id']
		@reply_body = options['reply_body']
	end 	
end 
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------

class Question_likes
	attr_accessor :likes_users_id, :likes_questions_id
	
	def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
    data.map { |datum| Question_likes.new(datum) }
	end
	
	def self.find_by_id(id)
		question_like = QuestionsDatabase.instance.execute(<<-SQL, id)
			SELECT
				*
			FROM
				question_likes
			WHERE
				id = ?
			SQL
    return nil unless question_like.length > 0
		
    Question_likes.new(question_like.first)
	end
	
	def initialize(options)
		@likes_users_id = options['likes_users_id']
		@likes_questions_id = options['likes_questions_id']
	end 	
end

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------

class Question_follows
	attr_accessor :users_id, :questions_id

	def self.all
		data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
		data.map { |datum| Question_follows.new(datum) }
	end
	
	def self.find_by_id(id)
		question_follow = QuestionsDatabase.instance.execute(<<-SQL, id)
			SELECT
				*
			FROM
				question_follows
			WHERE
				id = ?
		SQL
		return nil unless question_follow.length > 0

		Question_follows.new(question_follow.first)
	end

	def initialize(options)
		@users_id = options['users_id']
		@questions_id = options['questions_id']
	end 	
end 