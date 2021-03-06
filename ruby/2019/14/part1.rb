require 'pry'

Component = Struct.new(:amount, :material)
Recipe = Struct.new(:output_count, :ingredients)

def parse_component(text)
    text_count, material = text.split(' ')
    Component.new(text_count.to_i, material)
end

def parse_line(line)
    ingredients, product = line.split(" => ")
    ingredient_list = ingredients.split(", ")
    parsed_product = parse_component(product)
    [
        parsed_product.material,
        Recipe.new(
            parsed_product.amount,
            ingredient_list.map {|text| parse_component(text)}
        )
    ]
end

def div_ceil(amount_needed, recipe_output)
    (amount_needed + recipe_output - 1) / recipe_output
end

if __FILE__ == $0
    input = File.readlines('2019/14/puzzle-input.txt').map(&:chomp)

#    input = [
#        "10 ORE => 10 A",
#        "1 ORE => 1 B",
#        "7 A, 1 B => 1 C",
#        "7 A, 1 C => 1 D",
#        "7 A, 1 D => 1 E",
#        "7 A, 1 E => 1 FUEL",
#    ]

    parsed = input.map {|line| parse_line(line)}.to_h

    to_process = [
        Component.new(1, "FUEL")
    ]

    spares = {}
    spares.default = 0

    ore = 0

    until to_process.empty?
        current = to_process.shift
        recipe = parsed[current.material]

        taken_spares = 0
        #check if already have spares
        unless spares[current.material] == 0
            taken_spares = [current.amount, spares[current.material]].min
            spares[current.material] -= taken_spares
        end

        #build rest
        recipe_runs = div_ceil(current.amount - taken_spares, recipe.output_count)

        if recipe_runs == 0
            next
        end

        #return any left over spares
        spares[current.material] += (recipe_runs * recipe.output_count) - (current.amount - taken_spares)

        #enqueue ingredients
        recipe.ingredients.each do |ingredient|
            if ingredient.material == "ORE"
                ore += ingredient.amount * recipe_runs
            else
                #binding.pry
                to_process << Component.new(ingredient.amount * recipe_runs, ingredient.material)
            end
        end
        #binding.pry
    end
    puts ore
    binding.pry
end
