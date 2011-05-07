class Dir
  def self.in_dir(dir)
    current = Dir.pwd
    Dir.chdir dir
    yield
    Dir.chdir current
  end
end

# should possibly be elsewhere?  
def guarded(task)
  %x{#{task}}.tap { |x| raise "bad exit: #{$?.exitstatus},#{x}" if $?.exitstatus!=0 }
rescue => e
  raise e unless block_given?
  yield e
end
