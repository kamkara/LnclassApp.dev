class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
 

  enum :current_status, Student: "Student", Teacher: "Teacher",
                        City_manager: "City_manager", Educator: "Educator",
                        Develop: "Develop", Program_manager: "Program_manager",
                        Team: "Team", default: "Student"
                        
  after_initialize :set_default_current_status, :if => :new_record?

  def set_default_current_status
    self.current_status ||= :Student
  end

end
