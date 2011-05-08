require 'open4'
require 'awesome_print'

def announce(str)
  puts "    #{str}"
end

def guarded(task)
  pid, stdin, stdout, stderr = Open4.popen4 task
  ignored, status = Process.waitpid2 pid
 
  if status == 0
    stderr.read
    stdout.read
  else
    err = { :status => status, :stdout => stdout.read, :stderr => stderr.read }
    if block_given?
      yield err
    else
      abort "bad exit:\n#{ap err}"
    end
  end
  
end
