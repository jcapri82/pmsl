class DocumentsController < ApplicationController
  before_filter :authenticate_user!  #authenticate for users before any methods is called

  def index
    @documents = current_user.documents
  end

  def show
    @document = current_user.documents.find(params[:id])
  end

  def new
    @document = current_user.documents.new
    if params[:folder_id] #if we want to upload a file inside another folder 
      @current_folder = current_user.folders.find(params[:folder_id]) 
      @document.folder_id = @current_folder.id 
    end
  end

  def create
    @document = current_user.documents.new(params[:document])
    if @document.save
      flash[:notice] = "Successfully uploaded the file." 

      if @document.folder #checking if we have a parent folder for this file 
        redirect_to browse_path(@document.folder)  #then we redirect to the parent folder 
      else
        redirect_to root_url 
      end 
    else
      render :action => 'new'
    end
  end

  def edit
    @document = current_user.documents.find(params[:id])
  end

  def update
    @document = current_user.documents.find(params[:id])
    if @document.update_attributes(params[:document])
      redirect_to @document, :notice => "Successfully updated document."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @document = current_user.documents.find(params[:id])
    @parent_folder = @document.folder #grabbing the parent folder before deleting the record 
    @document.destroy 
    flash[:notice] = "Successfully deleted the file."
    if @parent_folder
      redirect_to browse_path(@parent_folder)
    else
      redirect_to root_url
    end
  end


#this action will let the users download the files (after a simple authorization check) 
  def get 
    # first find the asset within own documents
    document = current_user.documents.find_by_id(params[:id]) 
  
    # if not found in own documents, check if the current_user has share access to the parent folder of the file
    document ||= Document.find(params[:id]) if current_user.has_share_access?(Document.find_by_id(params[:id]).folder)

    if document 
      send_file document.uploaded_file.path, :type => document.uploaded_file_content_type, :x_sendfile=>true
    else
      flash[:error] = "No snooping! Mind your own documents!"
      redirect_to documents_path
    end
  end
end
