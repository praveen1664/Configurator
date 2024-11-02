RSpec::Matchers.define :match_config do |expected|
  match do |actual|
    def trimmed(text='')
      text.lines.collect{|line| line.strip}.select { |line| !line.empty?}.join "\n"
    end
    trimmed(actual) == trimmed(expected)


  end

  failure_message_for_should do |actual|
    "should match ignoring whitespace, differences: #{RSpec::Expectations::Differ.new.diff_as_string(trimmed(expected), trimmed(actual))}"
  end

end