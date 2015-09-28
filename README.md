# Nessus Automation - Ruby Gem

[![Gem Version](https://badge.fury.io/rb/moj-nessus-automation.svg)](http://badge.fury.io/rb/moj-nessus-automation)

## Dependencies

+ docker
+ boot2docker

## Description

A gem to help integrate automated security scans (using Nessus) into application feature/smoke tests

## Running Locally

The application is pointed to a Nessus instance via the NESSUS_HOST environment variable. For local development we have provided a simple setup script that will create and launch a dockerised Nessus instance through the setup.sh script. This will finish with a browser window prompting for login details and an activation key. This can be obtained from the [Tenable Security](https://www.tenable.com/products/nessus-home) site.

## Usage

Create a scan by defining a template name (default or user-defined) and a target URL

```ruby
  
  scan = Nessus::Scan.new(
    'webapp',
    'http://example.com/vulnerable'
  )

```

Launch the scan (can take a long time depending on complexity of the target)

```ruby

  scan.launch!

```

Once finished we can view and interrogate the raw JSON result

```ruby

  scan.view

```

Finally we can output to a csv

```ruby

  scan.export_csv('/tmp/nessus.csv')

```

For more details see the example.rb [script](https://github.com/ministryofjustice/nessus-automation/blob/master/lib/example.rb)


## Environment Variables

This is an up to date list of the environment variables used by the app.
Refer to the provisioning code for the actual values expected to be set on each
specific environment.

Variable Name          | Required for local development | Description
-----------------------| ------------------------------ | -----------------------------
`NESSUS_HOST`          | y                              | Hostname of the Nessus API
`NESSUS_USER`          | y                              | Nessus API username
`NESSUS_POST`          | y                              | Nessus API password