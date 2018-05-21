require "rails_helper"

RSpec.describe ProcessGameZipJob, type: :job do
  let(:job) { ProcessGameZipJob.new }
  let(:game_zip) do
    GameZip.create(file_key: sample_zip_path,
                   file_last_modified: 1.hour.ago,
                   user_id: 123,
                   game_id: 456)

  end

  context "the zip file isn't just a top-level folder" do
    let(:sample_zip_path) { "#{Rails.root}/spec/support/no_folder_sample.zip" }
    let(:tmpfile) { File.new(sample_zip_path) }

    before :each do
      job.instance_variable_set(:@local_tmp_file, tmpfile)
    end

    it "sets root files" do
      job.perform(game_zip.id)
      game_zip.reload
      expect(game_zip.root_files).to match_array ["game.exe", "hello.txt"]
    end

    it "closes the zip file" do
      allow(tmpfile).to receive(:close).and_call_original
      job.perform(game_zip.id)
      game_zip.reload
      expect(tmpfile).to have_received(:close)
    end
  end

end
