class ImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_parent
  before_action :set_image, except: [:create]
  before_action :permission_check!

  def create
    folder = params[:parent_type].underscore.pluralize
    filename = [
      @parent.id,
      "image",
      params[:filename]
    ].join("-")

    img = Image.new(parent: @parent,
                    user: current_user,
                    file_key: "#{folder}/#{filename}",
                    file_last_modified: Time.parse(params[:lastModifiedDate]))

    if img.save
      render json: img, status: :created
    else
      render json: { errors: img.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @parent.images.update_all(cover: false)
    @image.update(cover: params[:cover])
    redirect_to @parent
  end

  def destroy
    @image.destroy
    redirect_to @image.parent
  end

  private

  def set_parent
    valid = ["Game", "ArcadeMachine", "ApprovalRequest"]
    raise ArgumentError, "Invalid parent type #{params[:parent_type]}" if !valid.include?(params[:parent_type])

    klass = params[:parent_type].constantize
    @parent = klass.find(params[:parent_id])
  end

  def set_image
    @image = Image.find_by(id: params[:id])
  end

  def permission_check!
    require_admin_or_ownership!(@parent)
  end

end