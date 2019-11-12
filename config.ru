require 'rack/rewrite'
require 'uri'
require 'yaml'

config = YAML::load_file(File.join(__dir__, 'config.yml'))
REDIRECTS = config['redirects'] || []

use Rack::Rewrite do

  REDIRECTS.each do |entry|
    to = entry['to']
    to = "http://#{to}" if URI.parse(to).scheme.nil?

    from = Array entry['from']

    from.each do |from|
      r301 %r{.*}, "#{to}$&", if: -> (rack_env) { rack_env['SERVER_NAME'] == from }
    end

  end

end

# Fall back to default app (empty).
run -> (env) { [200, {}, []] }
