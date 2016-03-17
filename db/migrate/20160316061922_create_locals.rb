class CreateLocals < ActiveRecord::Migration
  def change
    create_table :locals do |t|
      t.string :name
      t.string :type
      t.integer :parent_id
      t.string :abbr
    end
  end
end
