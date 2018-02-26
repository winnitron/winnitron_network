class ProcessGameZipJob < ApplicationJob
  queue_as :default

  attr_accessor :game_zip, :local_tmp_file

  def perform(game_zip_id)
    @game_zip = GameZip.find(game_zip_id)

    download_zip

    # if only top-level folder?
    #   get *those* files
    #   build a new zip
    #   upload it
    #   @game_zip.update(file_key:)
    # end
    game_zip.update(root_files: root_files)
  ensure
    local_tmp_file&.close
    local_tmp_file&.unlink if local_tmp_file.respond_to?(:unlink)
  end

  private

  def root_files
    ::Zip::File.open(local_tmp_file) do |zip|
      zip.entries.map(&:name).reject { |fn| fn.include?(File::SEPARATOR) }
    end
  end

  def download_zip
    # A better solution might be:
    # upload directly to heroku ephemeral fs
    # do all the processing here
    # upload original (or the new constructed) to s3
    @local_tmp_file ||= begin
      Rails.logger.info("Downloading #{game_zip.file_key}")
      tmp = Tempfile.new(tmp_filename)
      open(tmp.path, "wb") { |f| f << open(game_zip.expiring_url).read }
      tmp
    end
  end

  def tmp_filename
    "gamezip-#{game_zip.id}"
  end


end
