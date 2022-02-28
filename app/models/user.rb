class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable, :trackable, authentication_keys:[:logged]
  

  #initializer
  after_initialize :set_default_current_status, :if => :new_record?
  before_validation :transform_emailAndContact?,  on: :create
  attr_writer :logged


  ####### RELATIONS ###### 
  has_many :materials
  has_many :levels
  #has_many :questions
  #has_many :courses
  #has_many :schools
  #has_many :classrooms
  #has_many :exercices
  #has_many :results
  #has_many :city_ereas
  
  
  enum :current_status, Student: "Student", Teacher: "Teacher",
  City_manager: "City_manager", Educator: "Educator",
  Develop: "Develop", Program_manager: "Program_manager",
  Team: "Team", default: "Student"
  
  

  ################## VALIDATES  ###############
   validates :first_name, :last_name, :full_name, :email, :password,
              :contact, :current_status, :city_name, presence: true
    
   validates :full_name,presence: true,
              format: { with: /\A[^0-9`!@#\$%\^&*+_=]+\z/ },
              length: { minimum:5, maximum: 30,
              message: "%{value} verifier votre nom complet"}

   validates :contact, uniqueness: true, numericality: { only_integer: true }, length: { minimum:10,
              message: "%{ value} verifier votre nom numéro est 10 chiffres"}

   validates :contact_money,  numericality: { only_integer: true }, length: { minimum:10,
              message: "%{ value} verifier votre nom numéro est 10 chiffres"}
              
   validates :current_status, inclusion: { in: %w(Student Teacher Team Program_manager Develop),
                    message: "%{value} acces non identifier" }

   ####### CUSTOM METHODES ###### 

  def set_default_current_status
    self.current_status ||= :Student
  end
  

  #Add transform N°matricule on email for student
  #contact on password
  def transform_emailAndContact?
    if self.current_status == "Student"
      self.email = "#{self.matricule}@gmail.com" 
      self.password = "#{self.contact}"
    else self.current_status == "Teacher"
      self.email = "#{self.contact}@gmail.com"     
    end    
  end
  #Team
  def user_team?
    if self.current_status != "Team"
      validates :city_name, presence: true, on: :create
    end
  end

  #custom full name
  def full_name
    self.full_name = "#{self.first_name} #{self.last_name}" 
  end  
  
  #slug custom
  def slug
    if self.role === "Student"
      self.slug = "civ #{self.full_name} #{self.user_id}"
    elsif self.role === "Teacher"
      self.slug = "civ #{self.full_name} #{self.material_name} #{self.user_id}"
    else
      self.slug = "civ #{self.full_name}"
      
    end
  end

  ################## SLUG ###############
  extend FriendlyId
  friendly_id :full_name, use: :slugged
  
  def should_generate_new_friendly_id?
    full_name_changed?
  end

  ################## BEFORE SAVE  #########
  before_save do
    self.contact            = contact.strip.squeeze(" ")
    self.matricule            = matricule.strip.squeeze(" ").uppercase
    self.contact_money      = contact_money.strip.squeeze(" ")
    self.first_name         = first_name.strip.squeeze(" ").downcase.capitalize
    self.last_name          = last_name.strip.squeeze(" ").downcase.capitalize
  end

  ################## LOGGED  #########
   
  def logged
    @logged || self.matricule || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if logged = conditions.delete(:logged)
      where(conditions.to_h).where(["lower(matricule) = :value OR lower(email) = :value", { :value => logged.downcase }]).first
    elsif conditions.has_key?(:matricule) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end
end
