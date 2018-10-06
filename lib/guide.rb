require "restaurant"
require "support/string_extend"

class  Guide

	class Config
		@@actions = ["list", "add", "find", "quit"]
		def self.actions; @@actions; end
	end

	def initialize(path=nil)
		Restaurant.filepath = path

		if Restaurant.file_exist?
			puts "Found the file"
		elsif Restaurant.create_file
			puts "created new file"			
		else
			puts "\n\n<<< Exiting.. >>>"
			exit!
		end
	end

	def launch!
		intoduction

		result = nil
		until result == :quit
			action, args = get_action
			result = do_action(action, args)			
		end

		conclusion  
	end

	def get_action
		action = nil
		until Guide::Config.actions.include? action 
			puts "Action: " + Guide::Config.actions.join(", ") if action
			print "> "		
			user_response = gets.chomp
			args = user_response.downcase.strip.split(' ')	
			action = args.shift		
		end

		return action, args
	end

	def do_action(action, args=[])
		case action
		when action = "add"
			add
		when action = "list"
			list(args)
		when action = "find"
			keyword = args.shift
			find keyword
		when action = "quit"
			return :quit
		else
			puts "\nI dont understand your command!\n"
		end
	end

	def add
		output_action_header("Add a restaurant")

		restaurant = Restaurant.build_using_questions

		if restaurant.save
			puts "\nRestaurant added\n\n"
		else
			puts "\nSave Error: Failed to save restaurant!\n\n"
		end
	end

	def list args

		sort_order = args.shift
		sort_order = args.shift if sort_order == "by"
		sort_order = "name" unless ['name', 'cuisine', 'price'].include?(sort_order)

		output_action_header("List all restaurants")
		restaurants = Restaurant.saved_restaurants

		restaurants.sort! do |r1, r2|
			case sort_order
			when "name"
				r1.name.downcase <=> r2.name.downcase
			when "cuisine"
				r1.cuisine.downcase <=> r2.cuisine.downcase	
			when "price"
				r1.price.to_i <=> r2.price.to_i		
			end
		end

		output_restaurant_tables restaurants
		puts("Sort using 'list name', 'list cuisine', 'list by name' ")
	end

	def find(keyword="")
		output_action_header("Find a restaurant")

		if keyword
			restaurants = Restaurant.saved_restaurants

			found = restaurants.select do |rest|
				rest.name.downcase.include?(keyword.downcase) ||
				rest.cuisine.downcase.include?(keyword.downcase) ||
				rest.price.to_i <= keyword.to_i
			end
			output_restaurant_tables found
		else
			puts "Find a restaurant by key phase\n"
			puts "For example 'Find Mexican', 'Find Mex'"

		end
	end

	def output_action_header title
		puts "\n#{title.upcase.center(60)}"
		puts "-" * 60
	end

	def output_restaurant_tables restaurants
		print " " + "Name".ljust(30)
		print " " + "Cuisine".ljust(20)
		print " " + "Price".ljust(6) + "\n"
		puts "-" * 60

		restaurants.each do |r|
			puts r.name.titleize.ljust(30)  + r.cuisine.titleize.ljust(20) + r.price.titleize.ljust(6)
		end

		puts "No restaurants listed" if restaurants.empty?
		puts "\n\n"
		puts "-" * 60		
	end


	def intoduction
		puts "\n\n<<< Welcome to food finder >>> \n\n"
		puts "<<< This is an interactive guide to find food from favourite restaurant >>> \n\n"
	end

	def conclusion
		puts "\n\n<<< Good Bye, Bon Appetite >>> \n\n"
	end
end