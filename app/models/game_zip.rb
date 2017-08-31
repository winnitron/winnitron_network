require "open-uri"
require "zip"

class GameZip < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  validates :user, :file_key, :file_last_modified, presence: true
  validate :is_a_zip

  def humanized_filename
    file_key.sub("games/", "")
  end

  def expiring_url
    object = Aws::S3::Object.new(bucket_name: ENV["AWS_BUCKET"], key: file_key)
    object.presigned_url(:get, expires_in: 1.hour)
  end

  def root_files
    Rails.cache.fetch("GameZip::#{id}::files") do

      tmp_file = Tempfile.new("gamezip-#{id}")

      @files ||= begin
        open(tmp_file.path, "wb") { |f| f << open(expiring_url).read }

        Zip::File.open(tmp_file) do |zip|
          zip.entries.map(&:name).reject { |fn| fn.include?(File::SEPARATOR) }
        end
      rescue OpenURI::HTTPError => e
        NewRelic::Agent.notice_error(e)
        []
      ensure
        tmp_file.close
        tmp_file.unlink
      end

    end
  end

  def likely_executable
    exes = root_files.select { |file| file.split(".").last == "exe" }
    html = root_files.select { |file| file.split(".").last == "html" }

    exes.first || html.first
  end

  private

  def is_a_zip
    if file_key && file_key[-4..-1].downcase != ".zip"
      errors.add(:file_key, "must be a .zip file")
    end
  end
end