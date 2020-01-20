# This is the repository
require "csv"
require_relative "recipe"

class Cookbook
  def initialize(csv_file_path)
    # loads existing Recipe from the CSV
    @csv_file_path = csv_file_path
    @csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
    @recipes = []
    CSV.foreach(@csv_file_path) do |row|
      @recipes << Recipe.new(row[0], row[1], row[2], row[3], row[4])
    end
  end

  def all
    # returns all the recipes
    @recipes
  end

  def add_recipe(recipe)
    # adds a new recipe to the cookbook
    @recipes << recipe
    rewrite_csv
  end

  def find_recipe(recipe_index)
    @recipes[recipe_index]
  end

  def remove_recipe(recipe_index)
    # removes a recipe from the cookbook
    @recipes.delete_at(recipe_index)
    rewrite_csv
  end

  def rewrite_csv
    CSV.open(@csv_file_path, 'wb', @csv_options) do |csv|
      @recipes.each { |rec| csv << [rec.name, rec.description, rec.prep_time, rec.done, rec.difficulty] }
    end
  end
end
