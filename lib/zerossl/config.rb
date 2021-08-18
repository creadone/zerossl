require 'logger'
require 'dry-configurable'

module ZeroSSL
  class Setup
    extend Dry::Configurable

    setting :api_uri,    'https://api.zerossl.com'
    setting :access_key, nil
    setting :logger,     Logger.new(STDOUT)
    setting :user_agent, "ZeroSSL Ruby Client / #{ZeroSSL::VERSION}"
  end
end