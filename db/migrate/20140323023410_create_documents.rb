class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.integer :user_id
      t.timestamps
    end

    add_index :documents, :user_id
  end

  def self.down
    drop_table :documents
  end
end
