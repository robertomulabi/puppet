require 'spec_helper'
require 'hiera_puppet'
require 'puppet/parser/functions/hiera_include'

describe 'Puppet::Parser::Functions#hiera_include' do
  let :scope do Puppet::Parser::Scope.new_for_test_harness('foo') end

  before :each do
    Puppet[:hiera_config] = PuppetSpec::Files.tmpfile('hiera_config')
  end

  it 'should require a key argument' do
    expect { scope.function_hiera_include([]) }.to raise_error(ArgumentError)
  end

  it 'should raise a useful error when nil is returned' do
    HieraPuppet.expects(:lookup).returns(nil)
    expect { scope.function_hiera_include(["badkey"]) }.
      to raise_error(Puppet::ParseError, /Could not find data item badkey/ )
  end

  it 'should use the array resolution_type' do
    HieraPuppet.expects(:lookup).with() { |*args| args[4].should be :array }.returns(['someclass'])
    expect { scope.function_hiera_include(['key']) }.to raise_error Puppet::Error, /Could not find class someclass/
  end
end
