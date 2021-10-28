require_relative 'setup'
require 'ruby_maven'
require 'stringio'
require 'maven/ruby/version'

describe RubyMaven do

  it 'displays the version info' do
    Dir.chdir 'spec' do
      CatchStdout.exec do
        RubyMaven.exec( '--version' )
      end
      _(CatchStdout.result).must_match /Polyglot Maven Extension 0.4.4/
      xml = File.read('.mvn/extensions.xml')
      _(xml).must_equal "dummy\n"
    end
  end

  let :gem_name do
    v = Maven::Ruby::VERSION
    v += '-SNAPSHOT' if v =~ /[a-zA-Z]/
    "pkg/ruby-maven-#{v}.gem"
  end

  it 'pack the gem' do
    FileUtils.rm_f gem_name
    CatchStdout.exec do
      # need newer jruby version
      RubyMaven.exec( '-Dverbose', 'package', '-Djruby.version=9.3.0.0' )
    end
    #puts CatchStdout.result
    _(CatchStdout.result).must_match /mvn -Dverbose package/
    _(File.exists?( gem_name )).must_equal true
    _(File.exists?( '.mvn/extensions.xml' )).must_equal true
    _(File.exists?( '.mvn/extensions.xml.orig' )).wont_equal true
  end
  
end
