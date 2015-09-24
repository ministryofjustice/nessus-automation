#! /usr/bin/env ruby

require 'securerandom'
require_relative 'nessus.rb'

# Create new client instance
client = Nessus::Client.new(
  Nessus::Settings.host,
  Nessus::Settings.username,
  Nessus::Settings.password,
  Nessus::Settings.ssl_verify
)

# Scan defined through command line parameters
# TODO: add proper support using commander gem
name, description, targets = ARGV

# Retrieve Scan Template
templates = client.list_template('scan')

# {
#   "is_agent"=>nil,
#   "desc"=>"Scan for published and unknown web vulnerabilities.",
#   "title"=>"Web Application Tests",
#   "name"=>"webapp",
#   "manager_only"=>false,
#   "subscription_only"=>false,
#   "uuid"=>"c3cbcd46-329f-a9ed-1077-554f8c2af33d0d44f09d736969bf",
#   "cloud_only"=>false
# }

# Create a new scan
name = 'test'
description = 'test'
targets = 'https://preprod-prisonvisits.dsd.io/prisoner'
uuid = 'c3cbcd46-329f-a9ed-1077-554f8c2af33d0d44f09d736969bf'

scan_data = client.scan_create(
  uuid,
  name,
  description,
  targets
)

# Launch the scan
scan_id = scan_data['scan']['id']
client.scan_launch(scan_id)

# Check scan status every interval
loop do
  data   = client.scan_details(scan_id)
  status = data['info']['status']

  if status != 'running'
    break
  else
    sleep Nessus::Settings.refresh_interval
  end
end

# View scan details
client.scan_details(scan_id)

# Export the scan
id  = client.scan_export(scan_id, 'csv')
csv = client.report_download(scan_id, id['file'])



