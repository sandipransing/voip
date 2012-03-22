class CreateCalls < ActiveRecord::Migration
  def self.up
    create_table :calls do |t|
      t.string :source
      t.string :name
      t.string :destination
      t.string :extension
      t.string :status
      t.string :path
      t.string :uniqueid

      t.timestamps
    end

    add_index :calls, [:destination, :status], :name => :new_call
    add_index :calls, :uniqueid
  end

  def self.down
    drop_table :calls
  end
end
