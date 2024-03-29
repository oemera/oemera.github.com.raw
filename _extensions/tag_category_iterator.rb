require 'open-uri'
require 'nokogiri'

# from kismetik-jekyll fork
module Jekyll
  class Site
    # Constuct an array of hashes that will allow the user, using Liquid, to
    # iterate through the keys of _kv_hash_ and be able to iterate through the
    # elements under each key.
    #
    # Example:
    #   categories = { 'Ruby' => [<Post>, <Post>] }
    #   make_iterable(categories, :index => 'name', :items => 'posts')
    # Will allow the user to iterate through all categories and then iterate
    # though each post in the current category like so:
    #   {% for category in site.categories %}
    #     h1. {{ category.name }}
    #     <ul>
    #       {% for post in category.posts %}
    #         <li>{{ post.title }}</li>
    #       {% endfor %}
    #       </ul>
    #   {% endfor %}
    # 
    # Returns [ {<index> => <kv_hash_key>, <items> => kv_hash[<kv_hash_key>]}, ... ]
    def make_iterable(kv_hash, options)
      options = {:index => 'name', :items => 'items'}.merge(options)
      result = []
      kv_hash.each do |key, value|
        result << { options[:index] => key, options[:items] => value }
      end
      result
    end    
  end
  
  AOP.around(Site, :site_payload) do |site_instance, args, proceed, abort|
    result = proceed.call
    
    tags = site_instance.make_iterable(site_instance.tags, :index => 'name', :items => 'posts')
    popular_tags = tags.to_a
    popular_tags.sort! {|a,b| b['posts'].size <=> a['posts'].size }
    popular_tags = popular_tags[0..19]

    result['site']['iterable'] = {
      'categories' => site_instance.make_iterable(site_instance.categories, :index => 'name', :items => 'posts'),
      'tags' => tags,
      'popular_tags' => popular_tags,
      #added by Jose
      'archives' => site_instance.posts.group_by{ |c| {"month" => "%02d" % c.date.month, 
                                                       "year" => c.date.year.to_s(), 
                                                       "month_name" => c.date.strftime("%B") } }
                    .each{ |period,posts| period["posts"] = posts }
                    .map{ |period, posts| period }
                    .reverse()
      ##############
    }
    result
  end
end