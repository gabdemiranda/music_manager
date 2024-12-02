class CreateSongs < ActiveRecord::Migration[7.2]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :artist
      t.string :album
      t.integer :duration
      t.string :genre

      t.timestamps
    end
  end
end
