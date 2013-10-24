Gem::Specification.new do |s|
  s.name        = 'rs-api-tools'
  s.version     = '0.0.5'
  s.date        = '2013-10-21'
  s.summary     = "rs-api-tools"
  s.description = "RightScale API Command Line Tools."
  s.authors     = ["Chris Fordham"]
  s.email       = 'chris@fordham-nagy.id.au'
  s.licenses    = ['Apache 2']
  s.bindir      = 'bin'
  s.executables = Dir.entries(s.bindir) - [".", "..", '.gitignore']
  s.homepage    =
    'https://github.com/flaccid/rs-api-tools'
  s.add_dependency "json", ">= 1.4.4"
  s.add_dependency 'rest_connection'
  s.add_dependency 'right_api_client'
  s.add_dependency 'octokit'
end