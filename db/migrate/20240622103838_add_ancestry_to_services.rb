class AddAncestryToServices < ActiveRecord::Migration[7.1]
  def change
    change_table(:services) do |s|
      s.string "ancestry", collation: 'C', null: false
      s.index "ancestry"
    end
  end
end
