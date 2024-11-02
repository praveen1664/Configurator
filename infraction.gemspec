Gem::Specification.new do |s|
  s.name = 'infraction'
  revcount = `git rev-list HEAD | wc -l`.strip
  s.version = "0.0.#{revcount}"
  s.date = '2013-08-01'
  s.authors = 'www-thoughtworks-com'
  s.email = 'www@thoughtworks.com'
  s.summary = s.description = 'simple infrastructure configuration generator, expressed in ruby'
  s.files = %w(lib/infraction.rb)
  s.homepage = 'https://github.com/www-thoughtworks-com/infraction'
  s.add_development_dependency 'rspec', '=2.14.1'
end