require 'spec_helper'

describe 'Primitives for symbols' do
  describe 'intern' do
    it 'converts a string to its corresponding symbol' do
      kl_eval('(intern "foo")').should == :foo
    end

    it 'converts the string "true" to boolean true' do
      kl_eval('(intern "true")').should == true
    end

    it 'converts the string "false" to boolean false' do
      kl_eval('(intern "false")').should == false
    end

    include_examples 'argument types', %w(intern "foo"), 1 => [:string]
  end
end
