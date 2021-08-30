class Api::V1::ContactsController < Api::V1::ApiController
  before_action :set_contact, only: %i[show update destroy]
  before_action :require_authorization!, only: %i[show update destroy]

  # GET /api/v1/contacts
  def index
    @contacts = current_user.contacts

    render json: @contacts
  end

  # GET contacts/1
  def show
    render json: @contact
  end

  # POST /contacts
  def create
    @contact = Contact.new(contact_params.merge(user: current_user))

    if @contact.save
      render json: @contact, status: :created
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT
  def update
    if @contact.update(contact_params)
      render json: @contact
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # DELETE
  def destroy
    @contact.destroy
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:name, :email, :phone, :description)
  end

  def require_authorization
    render json: {}, status: :forbidden unless current_user == @contact.user
  end
end
