class ImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_parent
  before_action :uuid_permission_check!

  def create
    folder = params[:parent_type].pluralize
    Image.create!(game_uuid: @parent.uuid,
                  user: current_user,
                  file_key: "#{folder}/#{@parent.uuid}-image-#{params[:filename]}",
                  file_last_modified: Time.parse(params[:lastModifiedDate]))

    render nothing: true
  end

  private

  def set_parent
    parent_types = ["game"]
    raise ArgumentError, "Invalid parent_type: #{params[:parent_type]}" if !parent_types.include?(params[:parent_type])

    klass = params[:parent_type].camelize.constantize
    @parent = klass.find_by(uuid: params[:uuid]) || klass.new(uuid: params[:uuid])
  end

  def uuid_permission_check!
    @parent.new_record? || require_admin_or_ownership!(@parent)
  end

end