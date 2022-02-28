class AddEnumTypeToUser < ActiveRecord::Migration[7.0]
  def up
  # note that enums cannot be dropped
  create_enum :status, [ "Student", "Teacher", "City_manager", "Educator", "Develop", "Program_manager", "Team" ]

  change_table :users do |t|
    t.enum :current_status, enum_type:  "status", default: "Student", null: false
  end
end
end