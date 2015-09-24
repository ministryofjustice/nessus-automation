#! /usr/bin/env ruby

require_relative 'nessus.rb'

# Create a new scan instance
scan = Nessus::Scan.new(
  'webapp',
  'https://preprod-prisonvisits.dsd.io/prisoner'
)

# Check details of scan created
scan.details

# Launch the scan
scan.launch!

# View scan result
scan.view

# Convenience methods for vulnerability management
scan.result.critical?
scan.result.high?
scan.result.medium?

# Export the scan as csv
scan.export_csv('/tmp/nessus.csv')





