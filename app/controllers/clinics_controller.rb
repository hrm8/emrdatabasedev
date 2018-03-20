class ClinicsController < ApplicationController

  before_action :authenticate, except: [:upload_file]

  def authenticate
    @clinic = Clinic.find_by_authentication_token(request.headers['X-TOKEN'])
    render json: {success: false}, :status => 401 if @clinic.nil?
  end

  def records
    @records = @clinic.records
    render 'records/index', :status => 202
  end

  def records_by_clinic
    @records = @clinic.records.where(user_id: params[:user_id], clinic_id: params[:clinic_id])
    render 'records/index', :status => 202
  end

  def access
    @share_request = ShareRequest.create(user_id: params[:user_id], clinic_id: @clinic.id)
    render 'share_requests/show', :status => 202
  end

  def upload_file

    #try auth clinic, Henrique como a frame do angular de upload n deixar eu colocar header estou passando o token por parametro
    @clinic = Clinic.find_by_authentication_token(params[:clinic_token])
    render json: {success: false, message: "clinic not valid"}, :status => 401 if @clinic.nil?

    #try upload to user
    @user = @clinic.users.find_by(id: params[:user_id])
    render json: {success: false, message: "user not validated on clinic"}, :status => 401 if @user.nil?

    #AZURE CONNECTION TO BLOB IMAGES
    blobs = Azure::Blob::BlobService.new
    blobs.set_container_acl("uploads", "container")

    file = params[:file]

    #Create randon
    rand_name=SecureRandom.urlsafe_base64(5)
    thumb_final_name = "#{rand_name}_#{file.original_filename}"

    #Parse thumb and send to azuere
    thumb_content = file.read
    puts file.content_type
    puts thumb_content.size

    blob = blobs.create_block_blob("uploads", "#{thumb_final_name}", thumb_content)

    puts "https://emergedb.blob.core.windows.net/uploads/#{thumb_final_name}"

    #Path do arquivo feito upload = "https://emergedb.blob.core.windows.net/uploads/#{thumb_final_name}"

    @record = Record.create(user_id: @user.id, clinic_id: @clinic.id, name: file.original_filename, url: thumb_final_name, mime_type: "image/jpeg")
    approved_clinics = @user.clinics - [@clinic]
    approved_clinics.map { |c| c.records << @record }

    render 'records/show', :status => 202
  end

  def search_all_users
    @users = User.where(email: params[:email])

    render 'users/index', :status => 202
  end

  def search_users
    @users = @clinic.users.search(params[:name], params[:phone], params[:email], params[:social])
    render 'users/index', :status => 202
  end

  def user_details
    @user = User.find_by(id: params[:user_id])

    #Rique mesmo eu n tendo acesso a todas as infos dele, precisa trazer o basico no minimo para montar a tela de detalhe conforme wire frame
    #Essa validação cabe para trazer dados como os reports dele para cada clinic, ai sim... teriamos que mover esse metodo pra uma rota comun de usuario
    #Pois as infos basicas e a clinica que ele pertence aparece no wire... ou muda o wire...

    (render json: {success: false, message: "user does not exist"}, :status => 406 && return) if @user.nil?
    render 'users/show_limited', :status => 202
  end

  def pending
    @share_requests = @clinic.share_requests.where(status: ShareRequest.statuses[:pending])
    render 'share_requests/index', :status => 202
  end

  def approved
    @share_requests = @clinic.share_requests.where(status: ShareRequest.statuses[:approved])
    render 'share_requests/index', :status => 202
  end

end
