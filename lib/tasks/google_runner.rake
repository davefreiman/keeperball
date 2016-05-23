task google_runner: :environment do
# Creates a session. This will prompt the credential via command line for the
# first time and save it to config.json file for later usages.
  session = GoogleDrive.saved_session(Rails.application.config.google_auth)

# Gets list of remote files.
  session.files.each do |file|
    p file.title
  end

# Uploads a local file.
  session.upload_from_file("/path/to/hello.txt", "hello.txt", convert: false)

# Downloads to a local file.
  file = session.file_by_title("hello.txt")
  file.download_to_file("/path/to/hello.txt")

# Updates content of the remote file.
  file.update_from_file("/path/to/hello.txt")
end

