require 'pry'

class Student
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.db
    DB[:conn]
  end

  def self.create_table
    sql = "CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT);"
    self.db.execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students;"
    self.db.execute(sql)
  end

  def save
    self.class.db.execute("INSERT INTO students (name, grade) VALUES (?, ?);", self.name, self.grade)
    @id = self.class.db.execute("SELECT id FROM students WHERE name = ?;", self.name).flatten.first
  end

  def self.create(student_hash)
    student = Student.new(student_hash[:name], student_hash[:grade])
    student.save
    student
  end

end
