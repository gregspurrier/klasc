require 'spec_helper'

describe 'Primitive functions for vectors' do
  describe '(absvector N)' do
    it 'returns a new absolute vector of size N' do
      kl_eval('(absvector 3)').should be_kind_of Absvector
    end

    it 'raises an error if N is negative' do
      expect {
        kl_eval('(absvector -1)')
      }.to raise_error(Kl::Error)
    end

    include_examples 'argument types', %w(absvector 7), 1 => [:integer]
  end

  describe '(address-> V N Value)' do
    before(:each) do
      kl_eval('(set *vec* (absvector 5))')
    end

    it 'returns the vector V updated with Value at index N' do
      kl_eval('(address-> (value *vec*) 3 37)').should be_kind_of Absvector
      kl_eval('(<-address (value *vec*) 3)').should == 37
    end

    it 'raises an error if N is negative' do
      expect {
        kl_eval('(address-> (value *vec*) -1 37)')
      }.to raise_error(Kl::Error)
    end

    it 'raises an error if N is >= the size of the vector' do
      expect {
        kl_eval('(address-> (value *vec*) 5 37)')
      }.to raise_error(Kl::Error)
      expect {
        kl_eval('(address-> (value *vec*) 99 37)')
      }.to raise_error(Kl::Error)
    end

    include_examples 'argument types',
                     ['address->', '(value *vec*)', '0', '37'],
                     2 => [:integer]
    include_examples 'partially-applicable function',
                     ['address->', '(value *vec*)', '0', '37']
  end

  describe '(<-address V N)' do
    before(:each) do
      kl_eval('(set *vec* (absvector 5))')
    end

    it 'returns the value previously stored at index N in V' do
      kl_eval('(address-> (value *vec*) 3 37)')
      kl_eval('(<-address (value *vec*) 3)').should == 37
    end

    it 'returns an unspecified value if index N has not been stored to' do
      expect {
        kl_eval('(<-address (value *vec*) 3)')
      }.to_not raise_error
    end

    it 'raises an error if N is negative' do
      expect {
        kl_eval('(<-address (value *vec*) -1)')
      }.to raise_error(Kl::Error)
    end

    it 'raises an error if N is >= the size of the vector' do
      expect {
        kl_eval('(<-address (value *vec*) 5)')
      }.to raise_error(Kl::Error)
      expect {
        kl_eval('(<-address (value *vec*) 99)')
      }.to raise_error(Kl::Error)
    end

    include_examples 'argument types',
                     ['<-address', '(value *vec*)', '0'],
                     2 => [:integer]
    include_examples 'applicative order evaluation',
                     ['<-address', '(value *vec*)', '0']
  end

  describe '(absvector? X)' do
    it 'returns true if X is an absvector' do
      kl_eval('(absvector? (absvector 1))').should == true
    end

    it 'returns a boolean of unspecified value when X was not created via absvector' do
      KL_TYPE_EXAMPLES.each do |t, example|
        next if t == :vector
        kl_eval("(absvector? #{example})").should satisfy { |v| [true,false].include? v }
      end
    end
  end
end
