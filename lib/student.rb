require 'pry'

class Student
  attr_accessor :id, :name, :grade


  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all

    sql = <<-SQL
      SELECT * FROM students
    SQL

    DB[:conn].execute(sql).map do |row| 
      self.new_from_db(row)
    end
  
  end

  
  def self.all_students_in_grade_9
    DB[:conn].execute("SELECT * FROM students WHERE grade = 9")
  end
  
  def self.students_below_12th_grade
    
    DB[:conn].execute("SELECT * FROM students WHERE grade < 12").map do |row|
      self.new_from_db(row)
    end
  end


  def self.first_X_students_in_grade_10(limit)
    DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?", limit).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    DB[:conn].execute("SELECT * FROM students WHERE grade = 10 ORDER BY students.id LIMIT 1").map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_X(grade)
    DB[:conn].execute("SELECT * FROM students WHERE grade = ?", grade).map do |row|
      self.new_from_db(row)
    end
  end
  
  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first

    ##SMOOTHER
    # student_data = DB[:conn].execute("SElECT * FROM students WHERE name = ?", name)
    # self.new_from_db(student_data[0])
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

end
