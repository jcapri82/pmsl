class Document < ActiveRecord::Base
  attr_accessible :user_id, :uploaded_file, :folder_id

  belongs_to :user
  belongs_to :folder

  #set up "uploaded_file" field as attached_file (using Paperclip) 
  has_attached_file :uploaded_file,
               :url => "/documents/get/:id",
               :path => ":Rails_root/documents/:id/:basename.:extension"  

  validates_attachment_size :uploaded_file, :less_than => 2.gigabytes   
  validates_attachment_presence :uploaded_file

  def file_name
    uploaded_file_file_name
  end

  def file_size
    uploaded_file_file_size
  end
end
