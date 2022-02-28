class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  enum current_status: [ :Student, :Teacher, :City_manager, :Educator, :Develop, :Program_manager, :Team ]
  after_initialize :set_default_current_status, :if => :new_record?

  def set_default_current_status
    self.current_status ||= :Student
  end

end
