require 'net/http'
require 'uri'

class LibrarianChefDSLParser
  attr_accessor :site, :cookbooks
  
  def initialize(cheffile, &data)
    @cheffile = cheffile
    @cookbooks = []
    data = false

    uri = URI.parse(cheffile)
    if %w( http https ).include?(uri.scheme)
      data = Net::HTTP.get(uri)
    else
      data = File.read(cheffile)
    end
    instance_eval data
  end

  def cheffile
    @cheffile
  end

  def site(*val)
    @site = val
  end

  def cookbook(name, options)
    cookbook = { "name" => name, "options" => options }
    @cookbooks.push(cookbook)
  end

end