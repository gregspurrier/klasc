require 'pty'
require 'expect'
require File.expand_path('../reader', __FILE__)

class Driver
  attr_reader :banner

  def initialize(command)
    @kl_out, @kl_in, @pid = PTY.spawn(command)
    @banner = nil
    read_banner
    load_kl_spec_repl
  end

  def read_banner
    @banner = @kl_out.expect(/\r\n(Shen(.*\r\n){4})/)[1].gsub("\r",'')
  end

  def load_kl_spec_repl
    @kl_out.expect(/\(0-\)/)
    kl_spec_repl_path = File.expand_path('../kl-spec-repl.shen', __FILE__)
    File.readlines(kl_spec_repl_path).each { |l| @kl_in.puts l }
    @kl_in.puts "(kl-spec-repl)"
    @kl_out.expect(/READY\r\n/)
  end

  def eval_kl(str)
    @kl_in.puts(str)
    result = @kl_out.expect(/\n=> (.*)\r\n/)[1]
    # puts '=> ' + result
    Reader.read_string(result)
  end
end
