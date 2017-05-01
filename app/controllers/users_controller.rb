require 'json'

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
 
  # GET /users
  def index
    #@users = User.all.take(10)
    #@users = User.find_each(start: 10, batch_size: 20)
    @users = User.all
    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  def sync
    data = params["data"]
    if(!data.nil?)
      # Added
      added = data["added"]
      if(!added.nil? && added.length > 0)
        inserted = []
        added.each do |c|
          user = User.new(c.permit(:id, :username, :password, :active))
          user.save
          inserted.push(user)
        end
        data["added"] = inserted
      end
      # Edited
      edited = data["edited"]
      if(!edited.nil? && edited.length > 0)
        modified = []
        edited.each do |c|
          user = User.find(c[:id])
          if(user)
            user.update(c.permit(:id, :username, :password, :active))
            #c = user
          end
          modified.push(user)
        end
        data["edited"] = modified
      end
      # Removed
      removed = data["removed"]
      if(!removed.nil? && removed.length > 0)
        removed.each do |c|
          user = User.find(c[:id])
          if(user)
            user.destroy
          end
        end
      end
    end
    render json: data
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:id, :username, :password, :active)
    end
end
