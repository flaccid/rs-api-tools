require 'net/http'
require 'uri'
require 'yaml'

class RightScaleMetadata

  def initialize(metadata_source, &metadata)
    @metadata_source = metadata_source
    metadata = false

    uri = URI.parse(metadata_source)
    if %w( http https ).include?(uri.scheme)
      @metadata = YAML.load(Net::HTTP.get(uri))
    else
      @metadata = YAML.load_file(metadata_source)
    end
  end

  def metadata_source
    @metadata_source
  end

  def metadata
    @metadata
  end
  
end
