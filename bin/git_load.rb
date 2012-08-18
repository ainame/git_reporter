$:.unshift File.join(File.dirname(__FILE__), '../lib')

require 'git'
require 'optparse'

exit(0) if ARGV.size == 0

git = Git.new(ARGV[0])
p git.log
