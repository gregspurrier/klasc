support_dir = File.expand_path('../support', __FILE__)
Dir.glob(File.join(support_dir, '*.rb')) { |rb| require rb }

def reset_driver
  command = ENV['SHEN_COMMAND'] || 'shen-repl'
  $driver = Driver.new(command)
  $driver.eval_kl('(defun kl-do (X Y) Y)')
end
reset_driver

puts "Testing KLamba specification compliance of:"
puts
puts $driver.banner
puts

# Helper function that evaluates a string in the K Lambda environment and
# returns the result as a Ruby object.
def kl_eval(str)
  # puts str
  begin
    $driver.eval_kl(str)
  rescue => e
    unless e.kind_of? Kl::Error
      reset_driver
    end
    raise e
  end
end

# Defines the 'kl-do' function in the current K Lambda environment. This is
# used instead of 'do' because do is not an official K Lambda primitive
# and may not be found in all K Lambda implementations.
def define_kl_do
end
