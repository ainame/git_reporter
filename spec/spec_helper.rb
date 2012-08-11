require "rspec"
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "lib"))

require "pp"
require "awesome_print"

require "git_reporter"
require "git"
require "git/blob"
