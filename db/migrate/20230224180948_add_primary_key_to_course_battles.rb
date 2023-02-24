class AddPrimaryKeyToCourseBattles < ActiveRecord::Migration[7.0]
  def change
    execute "ALTER TABLE course_battles ADD PRIMARY KEY (id)"
  end
end
