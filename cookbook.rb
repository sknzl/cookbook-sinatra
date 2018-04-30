require 'csv'
require_relative "recipe"

class Cookbook
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes = []
    CSV.foreach(csv_file_path) do |row|
      # Here, row is an array of columns
      @recipes << Recipe.new(row[0], row[1])
    end
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    CSV.open(@csv_file_path, "a") do |csv|
      csv << [recipe.name, recipe.description]
    end
  end

  def remove_recipe(recipe_index)
    # binding.pry
    @recipes.delete_at(recipe_index)
    CSV.open(@csv_file_path, "w") do |csv|
      @recipes.each do |element|
        csv << [element.name, element.description]
      end
    end
  end
end
