require "bundler"
Bundler.setup

$:.unshift(Pathname(__FILE__).dirname.parent + "lib")

require "postscript"
