require File.expand_path('../absvector', __FILE__)
require File.expand_path('../cons', __FILE__)
require File.expand_path('../function', __FILE__)

module Kl
  class Error < StandardError
  end
end

module Reader
  class << self
    def read_string(str)
      tokens = tokenize(str)
      parse(tokens)
    end

    def parse(tokens)
      raise "parse error" unless tokens.shift == '('
      
      value = case tokens.shift
              when 'symbol'
                tokens.shift.intern
              when 'string'
                tokens.shift
              when 'integer'
                tokens.shift.to_i
              when 'real'
                tokens.shift.to_f
              when 'boolean'
                tokens.shift == 'true'
              when 'absvector'
                Absvector.new(tokens.shift)
              when 'function'
                Function.new
              when 'cons'
                Cons.new(parse(tokens), parse(tokens))
              when 'empty-list'
                Cons::EMPTY_LIST
              when 'error'
                raise Kl::Error, tokens.shift
              when 'unknown'
                Unknown.new(tokens.shift)
              else
                raise "unexpected value"
              end

      raise 'parse error' unless tokens.shift == ')'
      value
    end

    def tokenize(str)
      chars = str.chars.to_a
      tokens = []
      token = ''

      finish_token = lambda do
        unless token.empty?
          tokens << token
          token = ''
        end
      end

      until chars.empty?
        char = chars.shift
        case char
        when /\s/
          finish_token.call
        when '(', ')'
          finish_token.call
          tokens.push char
        when '"'
          tokens.push drain_string!(chars)
        else
          token << char
        end
      end

      finish_token.call
      tokens
    end

    def drain_string!(chars)
      token = ''
      until chars.empty?
        char = chars.shift
        case char
        when '"'
          return token
        when '\\'
          token << chars.shift
        else
          token << char
        end
      end
    end
  end
end
