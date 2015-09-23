require 'securerandom'
require_relative 'nessus.rb'

# Create new client instance
client = Nessus::Client.new(
  Nessus::Settings.host,
  Nessus::Settings.username,
  Nessus::Settings.password,
  'ssl_verify'
)

# Create a new scan
uuid = SecureRandom.uuid
scan = client.scan_create(
  uuid,
  #name,
  #description,
  #targets
)

# Launch the scan
client.scan_launch(uuid)

# Check scan status every interval
loop do
  
end

# Export the scan


# Check scan status every interval
loop do

end

# Download report
client.report_download(uuid, file_id)
