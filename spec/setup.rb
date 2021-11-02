$LOAD_PATH.unshift File.expand_path( '../../lib', __FILE__ )

ENV["MT_NO_PLUGINS"] = "true"

require 'minitest/autorun'


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
