class JavascriptsController < ApplicationController
  def dynamic_states
    @states = State.find(:all)
  end
end
