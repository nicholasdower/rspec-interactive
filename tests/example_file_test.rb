require_relative 'support/test_helper'

RSpec.configuration.backtrace_exclusion_patterns = [ /.*/ ]
RSpec.configuration.backtrace_inclusion_patterns = [ /examples\/failing_spec.rb/ ]

examples = Tempfile.new('examples')

config = Tempfile.new('config')
config.write <<~EOF
  RSpec::Interactive.configure do |config|
    config.configure_rspec do
      RSpec.configuration.example_status_persistence_file_path = "#{examples.path}"
    end
  end
EOF
config.rewind

Test.test "failing spec with example file", config_path: config.path do
  await_prompt
  input "rspec examples/failing_spec.rb"
  await_prompt
  input "exit"
  await_termination
  expect_output <<~EOF
    [1] pry(main)> rspec examples/failing_spec.rb
    F

    Failures:

      1) example spec fails
         Failure/Error: expect(true).to eq(false)

           expected: false
                got: true

           (compared using ==)

           Diff:
           @@ -1 +1 @@
           -false
           +true
         # ./examples/failing_spec.rb:5:in `block (2 levels) in <top (required)>'

    Finished in 0 seconds (files took 0 seconds to load)
    1 example, 1 failure

    Failed examples:

    rspec ./examples/failing_spec.rb:4 # example spec fails

    Rerun failures by executing the previous command with --only-failures or --next-failure.

    [2] pry(main)> exit
  EOF
end

config.close
examples.close
