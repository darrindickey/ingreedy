require 'spec_helper'

RSpec::Matchers.define :parse_the_unit do |unit|
  match do |ingreedy_output|
    ingreedy_output.unit == unit
  end
  failure_message_for_should do |ingreedy_output|
    "expected to parse the unit #{unit} from the query '#{ingreedy_output.query}' " +
    "got '#{ingreedy_output.unit}' instead"
  end
end
RSpec::Matchers.define :parse_the_amount do |amount|
  match do |ingreedy_output|
    ingreedy_output.amount == amount
  end
  failure_message_for_should do |ingreedy_output|
    "expected to parse the amount #{amount} from the query '#{ingreedy_output.query}.' " +
    "got '#{ingreedy_output.amount}' instead"
  end
end

describe "amount formats" do
  before(:all) do
    @expected_amounts = {}
    @expected_amounts["1 cup flour"] = 1.0
    @expected_amounts["1 1/2 cups flour"] = 1.5
    @expected_amounts["1.0 cup flour"] = 1.0
    @expected_amounts["1.5 cups flour"] = 1.5
    @expected_amounts["1 2/3 cups flour"] = 1 + 2/3.to_f
    @expected_amounts["1 (28 ounce) can crushed tomatoes"] = 28
    @expected_amounts["2 (28 ounce) can crushed tomatoes"] = 56
    @expected_amounts["1/2 cups flour"] = 0.5
    @expected_amounts[".25 cups flour"] = 0.25
    # zobar uncovered this bug:
    @expected_amounts["12oz tequila"] = 12
  end
  it "should parse the correct amount as a float" do
    @expected_amounts.each do |query, expected|
      Ingreedy.parse(query).should parse_the_amount(expected)
    end
  end
end

describe "english units" do
  context "abbreviated" do
    before(:all) do
      @expected_units = {}
      @expected_units["1 c flour"] = :cup
      @expected_units["1 c. flour"] = :cup
      @expected_units["1 fl oz flour"] = :fluid_ounce
      @expected_units["1 fl. oz. flour"] = :fluid_ounce
      @expected_units["1 (28 fl oz) can crushed tomatoes"] = :fluid_ounce
      @expected_units["2 gal flour"] = :gallon
      @expected_units["2 gal. flour"] = :gallon
      @expected_units["1 ounce flour"] = :ounce
      @expected_units["2 ounces flour"] = :ounce
      @expected_units["1 oz flour"] = :ounce
      @expected_units["1 oz. flour"] = :ounce
      @expected_units["2 pt flour"] = :pint
      @expected_units["2 pt. flour"] = :pint
      @expected_units["1 lb flour"] = :pound
      @expected_units["1 lb. flour"] = :pound
      @expected_units["1 pound flour"] = :pound
      @expected_units["2 pounds flour"] = :pound
      @expected_units["2 qt flour"] = :quart
      @expected_units["2 qt. flour"] = :quart
      @expected_units["2 qts flour"] = :quart
      @expected_units["2 qts. flour"] = :quart
      @expected_units["2 tbsp flour"] = :tablespoon
      @expected_units["2 tbsp. flour"] = :tablespoon
      @expected_units["2 Tbs flour"] = :tablespoon
      @expected_units["2 Tbs. flour"] = :tablespoon
      @expected_units["2 T flour"] = :tablespoon
      @expected_units["2 T. flour"] = :tablespoon
      @expected_units["2 tsp flour"] = :teaspoon
      @expected_units["2 tsp. flour"] = :teaspoon
      @expected_units["2 t flour"] = :teaspoon
      @expected_units["2 t. flour"] = :teaspoon
      # zobar uncovered this bug:
      @expected_units["12oz tequila"] = :ounce
      @expected_units["2 TSP flour"] = :teaspoon
      @expected_units["1 LB flour"] = :pound
    end
    it "should parse the units correctly" do
      @expected_units.each do |query, expected|
        # Ingreedy.parse(query).unit.should == expected
        Ingreedy.parse(query).should parse_the_unit(expected)
      end
    end
  end
  context "long form" do
    before(:all) do
      @expected_units = {}
      @expected_units["1 cup flour"] = :cup
      @expected_units["2 cups flour"] = :cup
      @expected_units["1 fluid ounce flour"] = :fluid_ounce
      @expected_units["2 fluid ounces flour"] = :fluid_ounce
      @expected_units["2 gallon flour"] = :gallon
      @expected_units["2 gallons flour"] = :gallon
      @expected_units["2 pint flour"] = :pint
      @expected_units["2 pints flour"] = :pint
      @expected_units["1 quart flour"] = :quart
      @expected_units["2 quarts flour"] = :quart
      @expected_units["2 tablespoon flour"] = :tablespoon
      @expected_units["2 tablespoons flour"] = :tablespoon
      @expected_units["2 teaspoon flour"] = :teaspoon
      @expected_units["2 teaspoons flour"] = :teaspoon
    end
    it "should parse the units correctly" do
      @expected_units.each do |query, expected|
        Ingreedy.parse(query).unit.should == expected
      end
    end
  end
end

describe "metric units" do
  context "abbreviated" do
    before(:all) do
      @expected_units = {}
      @expected_units["1 g flour"] = :gram
      @expected_units["1 g. flour"] = :gram
      @expected_units["1 gr flour"] = :gram
      @expected_units["1 gr. flour"] = :gram
      @expected_units["1 kg flour"] = :kilogram
      @expected_units["1 kg. flour"] = :kilogram
      @expected_units["1 l water"] = :liter
      @expected_units["1 l. water"] = :liter
      @expected_units["1 mg water"] = :milligram
      @expected_units["1 mg. water"] = :milligram
      @expected_units["1 ml water"] = :milliliter
      @expected_units["1 ml. water"] = :milliliter
    end
    it "should parse the units correctly" do
      @expected_units.each do |query, expected|
        Ingreedy.parse(query).unit.should == expected
      end
    end
  end
  context "long form" do
    before(:all) do
      @expected_units = {}
      @expected_units["1 gram flour"] = :gram
      @expected_units["2 grams flour"] = :gram
      @expected_units["1 kilogram flour"] = :kilogram
      @expected_units["2 kilograms flour"] = :kilogram
      @expected_units["1 liter water"] = :liter
      @expected_units["2 liters water"] = :liter
      @expected_units["1 milligram water"] = :milligram
      @expected_units["2 milligrams water"] = :milligram
      @expected_units["1 milliliter water"] = :milliliter
      @expected_units["2 milliliters water"] = :milliliter
    end
    it "should parse the units correctly" do
      @expected_units.each do |query, expected|
        Ingreedy.parse(query).unit.should == expected
      end
    end
  end
end

describe "nonstandard units" do
  before(:all) do
    @expected_units = {}
    @expected_units["1 pinch pepper"] = :pinch
    @expected_units["2 pinches pepper"] = :pinch
    @expected_units["1 dash salt"] = :dash
    @expected_units["2 dashes salt"] = :dash
    @expected_units["1 touch hot sauce"] = :touch
    @expected_units["2 touches hot sauce"] = :touch
    @expected_units["1 handful rice"] = :handful
    @expected_units["2 handfuls rice"] = :handful
  end
  it "should parse the units correctly" do
    @expected_units.each do |query, expected|
      Ingreedy.parse(query).unit.should == expected
    end
  end
end

describe "without units" do
  before(:all) { @ingreedy = Ingreedy.parse "3 eggs, lightly beaten" }

  it "should have an amount of 3" do
    @ingreedy.amount.should == 3
  end

  it "should have a nil unit" do
    @ingreedy.unit.should be_nil
  end

  it "should have the correct ingredient" do
    @ingreedy.ingredient.should == "eggs, lightly beaten"
  end
end

describe "ingredient formatting" do
  #before(:all) {
    @expected_results = {
        '1 c. flour' => 'flour',
        '1  c. Crisco shortening' => 'Crisco shortening',
        '2  large Granny Smith apples, diced' => 'Granny Smith apples',
        '2 to 3  Tbsp. chili powder' => 'chili powder',
        '7 to 7 1/2  c. all-purpose flour' => 'all-purpose flour',
        '1  pkg. active dry yeast' => 'active dry yeast',
        'pinch of nutmeg' => 'nutmeg',
        '6-8 c. bread crumbs' => 'bread crumbs',
        '1  jar Ragu spaghetti sauce (15 1/2 oz.)' => 'Ragu spaghetti sauce',
        '1  1/2 t. baking soda' => 'baking soda',
        '1 8  oz. cream cheese' => 'cream cheese',
        '1  (18.25 oz.)  Betty Crocker devils food SuperMoist cake mix (dry; do not make as directed on the box)' => 'Betty Crocker devils food SuperMoist cake mix',
        '(17.3 ounces) Pepperidge Farm Puff Pastry Sheets , thawed' => 'Pepperidge Farm Puff Pastry Sheets',
        '1 1/2 cups all-purpose flour' => 'all-purpose flour',
        '1 1/2 cups (6.75 ounces or 195 grams) all-purpose flour' => 'all-purpose flour',
        '3 1/2 cups flour, plus additional for the work surface' => 'flour',
        '1/8 teaspoon ground nutmeg' => 'ground nutmeg',
        '1/2 cup buttermilk' => 'buttermilk',
        'Vegetable oil or shortening (see my explanation in the post) for frying' => 'Vegetable oil or shortening',
        '4 tablespoons (1/2 stick or 2 ounces) butter, at room temperature' => 'butter',
        '1 cup white wine (they suggest 1/2 cup but I need more to steam that volume)' => 'white wine',
        '1 handful fresh flat-leaf parsley leaves, minced' => 'fresh flat-leaf parsley leaves',
        'Coarse or pearl sugar for sprinkling (optional)' => 'Coarse or pearl sugar for sprinkling',
        '1 15-ounce can of white cannelini or navy beans, drained and rinsed' => 'white cannelini or navy beans',
        '1 1/2 teaspoons (.17 oz.) instant yeast' => 'instant yeast',
        '1 stick (1/2cup) unsalted butter, melted' => 'unsalted butter',
        '2 pounds cooked lobster meat*, chopped roughly into 1/2 and 3/4-inch pieces' => 'cooked lobster meat',
        'Seeds from 1/2 vanilla bean (or 2 teaspoons of vanilla extract)' => 'Seeds from 1/2 vanilla bean',
        '3 medium mixed bell peppers (orange, yellow, green)' => 'mixed bell peppers',
        'Thyme sprigs for garnish. ' => 'Thyme sprigs for garnish',
        '1 (14- to 19-ounce) can chickpeas, rinsed and drained' => 'chickpeas',
        '3-pound chicken, in parts or 3 pounds chicken pieces of your choice' => 'chicken',
        '17.3-ounce package Pepperidge Farm Puff Pastry Sheets (1 sheet), thawed' => 'Pepperidge Farm Puff Pastry Sheets',
        'skinless, boneless chicken breasts or thighs' => 'skinless boneless chicken breasts or thighs',
        'skinless, boneless chicken breast halves (about 1 pound)' => 'skinless boneless chicken breast halves'
    }
  #}

  @expected_results.each_pair do |raw, expected|
    it "should convert '#{raw}' to '#{expected}'" do
      expect(Ingreedy.parse(raw).ingredient).to eq(expected)
    end
  end
end
