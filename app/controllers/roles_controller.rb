class RolesController < ApplicationController
  before_action :set_role, only: [:show, :update, :destroy]

  # GET /roles
  def index
    @roles = Role.all

    render json: @roles
  end

  # GET /roles/1
  def show
    render json: @role
  end

  # POST /roles
  def create    
    @role = Role.new(role_params)
    
    if @role.save
      render json: @role, status: :created, location: @role
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /roles/1
  def update
    if @role.update(role_params)
      render json: @role
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  # DELETE /roles/1
  def destroy
    @role.destroy
  end

  def sync
    data = params["data"]
    if(!data.nil?)
      # Added
      added = data["added"]
      if(!added.nil? && added.length > 0)
        inserted = []
        added.each do |c|
          role = Role.new(c.permit(:id, :name, :description, :active))
          role.save
          inserted.push(role)
        end
        data["added"] = inserted
      end
      # Edited
      edited = data["edited"]
      if(!edited.nil? && edited.length > 0)
        modified = []
        edited.each do |c|
          role = Role.find(c[:id])
          if(role)
            role.update(c.permit(:id, :name, :description, :active))
            #c = role
          end
          modified.push(role)
        end
        data["edited"] = modified
      end
      # Removed
      removed = data["removed"]
      if(!removed.nil? && removed.length > 0)
        removed.each do |c|
          role = Role.find(c[:id])
          if(role)
            role.destroy
          end
        end
      end
    end
    render json: data
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def role_params
      params.require(:role).permit(:name)
    end
end
