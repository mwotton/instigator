# must be a nicer way of doing this
# $LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
Dir['lib/*.rb'].each {|lib| require(File.basename lib) rescue "couldn't load #{lib}"}


