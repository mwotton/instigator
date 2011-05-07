class Dir
  def self.in_dir(dir)
    current = Dir.pwd
    Dir.chdir dir
    yield
    Dir.chdir current
  end
end

    
