require_relative 'setup'
require 'ruby_maven'
require 'stringio'
require 'maven/ruby/version'

module CatchStdout

  def self.exec
    out = $stdout
    err = $stderr
    @result = StringIO.new
    $stdout = @result
    $stderr = @result
    yield
  ensure
    $stdout = out
    $stderr = err
  end

  def self.result
    @result.string
  end
end

describe RubyMaven do

  it 'displays the version info' do
    Dir.chdir 'spec' do
      CatchStdout.exec do
        RubyMaven.exec( '--version' )
      end
      CatchStdout.result.must_match /Polyglot Maven Extension 0.1.15/
      xml = File.read('.mvn/extensions.xml')
      xml.must_equal "dummy\n"
    end
  end

  let :gem do
    v = Maven::Ruby::VERSION
    v += '-SNAPSHOT' if v =~ /[a-zA-Z]/
    "pkg/ruby-maven-#{v}.gem"
  end

  it 'pack the gem' do
    FileUtils.rm_f gem
    CatchStdout.exec do
      RubyMaven.exec( '-Dverbose', 'package' )
    end
    CatchStdout.result.must_match /mvn -Dverbose package/
    File.exists?( gem ).must_equal true
    File.exists?( '.mvn/extensions.xml' ).must_equal true
    File.exists?( '.mvn/extensions.xml.orig' ).wont_equal true
  end
  
end
