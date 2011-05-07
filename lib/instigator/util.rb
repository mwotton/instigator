
# TODO: swallow output unless there's an error
def guarded(task)
  %x{#{task}}.tap { |x| raise "bad exit: #{$?.exitstatus},#{x}" if $?.exitstatus!=0 }
rescue => e
  if block_given?
    yield e
  else
    raise e
  end
end
