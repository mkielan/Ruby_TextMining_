$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'text_mining'

$test_results_dir = '.'
$start_test_time = Time.new

def prepare_test_results_dir title = nil
  dirs = []

  $test_results_dir = "#{File.dirname(__FILE__)}/test_results"
  dirs << $test_results_dir

  $test_results_dir += "/#{$start_test_time.strftime('%Y-%m-%d')}"
  dirs << $test_results_dir

  $test_results_dir += "/#{$start_test_time.strftime('%H%M%S')}"
  $test_results_dir += "(#{title})" if !title.nil?
  dirs << $test_results_dir

  dirs.length.times { |i| Dir.mkdir dirs[i] if !Dir.exist? dirs[i] }
end
=begin
#
# In the future it will be method to write log of test unit.
#
def log text

end
=end