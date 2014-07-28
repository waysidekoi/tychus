# Tychus

Recipe parser supporting microformats for:

  * [Schema.org/Recipe](https://support.google.com/webmasters/answer/173379?hl=en)

Compatible with:
  
  * [Allrecipes](http://allrecipes.com)
  * [Food Network](http://www.foodnetwork.com)
  * [Kraft Recipes](http://www.kraftrecipes.com)

## Installation

Add this line to your application's Gemfile:

    gem 'tychus'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tychus

## Usage

```
'require tychus'   
recipe = Tychus.parse('http://allrecipes.com/Recipe/Chicken-Pot-Pie-IX/Detail.aspx?soid=recs_recipe_2')

recipe.name
=> "Chicken Pot Pie IX"
recipe.author
=> "Robbie Rice"
recipe.description
=> "\"A delicious chicken pie made from scratch with carrots, peas and celery.\""
recipe.ingredients
=> ["1 pound skinless, boneless chicken breast halves - cubed", "1 cup sliced carrots", "1 cup frozen green peas", "1/2 cup sliced celery", "1/3 cup butter", "1/3 cup chopped onion", "1/3 cup all-purpose flour", "1/2 teaspoon salt", "1/4 teaspoon black pepper", "1/4 teaspoon celery seed", "1 3/4 cups chicken broth", "2/3 cup milk", "2 (9 inch) unbaked pie crusts"]
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/tychus/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
