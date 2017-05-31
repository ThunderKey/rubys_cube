source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'mittsu', github: 'ThunderKey/mittsu', branch: 'bug-mesh-face-material'

# Specify your gem's dependencies in rubys_cube.gemspec
gemspec
