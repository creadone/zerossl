require 'uri'
require 'json'
require 'net/http'

module ZeroSSL
  class HTTP

    VERBS = {
      get:  Net::HTTP::Get,
      post: Net::HTTP::Post
    }

    Response = Struct.new(:code, :success, :body)

    def initialize
      @api_uri    = Setup.config.api_uri
      @access_key = Setup.config.access_key
      @logger     = Setup.config.logger
      @user_agent = Setup.config.user_agent
    end

    def default_headers(opts = {})
      {
        'User-Agent'   => @user_agent,
        'Content-Type' => 'application/json',
      }.merge!(opts)
    end

    def default_params(opts = {})
      {
        'access_key' => @access_key
      }.merge!(opts)
    end

    def get(path, options = {})
      execute(path, :get, options)
    end

    def post(path, options = {})
      execute(path, :post, options)
    end

    private
      def execute (path, method, options = {})
        # Build URL
        url       = URI.join(@api_uri, path)
        url.query = URI.encode_www_form(default_params.to_a)

        # Build request
        req = VERBS[method].new(url)
        options.transform_keys!(&:to_s) unless options.empty?
        default_headers.each{ |k,v| req[k] = v }
        req.set_form_data(options.dig('body') || options || {})

        # Execute request
        ssl_conf = { :use_ssl => url.scheme == 'https' }
        resp = Net::HTTP.start(url.hostname, url.port, ssl_conf) do |http|
          http.request(req)
        end

        # Parse response
        body = resp.body.empty? ? {} : JSON.parse(resp.body)
        Response.new(resp.code.to_i, !body.dig('error'), body)

        rescue => e
          @logger.error(e.message) if @logger
          raise e
      end
  end
end