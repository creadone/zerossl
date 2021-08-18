# ZeroSSL

Ruby client to obtain SSL certificate from [ZeroSSL](https://zerossl.com) via [REST API](https://zerossl.com/documentation/api/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'zerossl'
```

And then execute:
```ruby
$ bundle install
```
Or install it yourself as:
```ruby
$ gem install zerossl
```
## Usage

```ruby
require 'zerossl'

# Setup gem
ZeroSSL::Setup.config.access_key = '123456789'
client = ZeroSSL::Client.new

# Define domain and server html path
domain_name    = 'umbrella.llc'
html_directory = '/var/www/html'

# Set Certificate Signing Request options
csr_opts = {
  common_name:  domain_name,
  organization: 'Umbrella',
  country:      'RU',
  state_name:   'Moscow',
  locality:     'Moscow'
}

# Build CSR
csr, key = ZeroSSL::CSR.new(csr_opts).call

# Build certificate request
request = {
  certificate_domains:        [domain_name],
  certificate_validity_days:  ZeroSSL::VALIDITY_DAYS::DAY90,
  certificate_csr:            csr
}

# Receive request, extract certificate id and validation details
response       = client.create(request).body
certificate_id = response['id']
other_methods  = response['validation']['other_methods']

# Write validation content into file to the server directory
other_methods.each do |domain_name, validation_types|
  validation_uri     = URI(validation_types['file_validation_url_http'])
  validation_content = validation_types['file_validation_content']

  File.open(File.join(html_directory, validation_uri.path), 'w') do |io|
    io << validation_content.join("\n")
  end
end

# Tell ZeroSSL domain are ready for validation
client.verify(certificate_id, ZeroSSL::VALIDATION_TYPE::HTTP)
#=> { [...] validation => { other_methods => { <domain> => file_validation_url_http }}}

# Check validation status
client.status(certificate_id)
#=> true

# Download Certificate (inline)
client.download(certificate_id)
#=> {
#    "certificate.crt": "---BEGIN CERTIFICATE---{primary_certificate}---END CERTIFICATE---",
#    "ca_bundle.crt": "---BEGIN CERTIFICATE---{certificate_bundle}---END CERTIFICATE---"
# }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/creadone/zerossl.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
