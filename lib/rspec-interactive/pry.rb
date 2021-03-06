require 'pry'

class Pry
  alias_method :old_eval, :eval

  def eval(line, options = {})
    RSpec::Interactive.eval(line, options) do
      old_eval(line, options)
    end
  end
end

