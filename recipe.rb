class Recipe
  attr_reader :name, :description, :state
  attr_writer :state

  def initialize(name, description, state = false)
    # TODO: implement constructor with relevant instance variables
    @name = name
    @description = description
    @state = state
  end

end
