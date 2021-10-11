class Movie < ActiveRecord::Base
  def self.all_ratings
   movies = Movie.select('DISTINCT rating')
   array_ratings = []
   movies.each do |movie|
     array_ratings.push(movie.rating)
    end
   array_ratings
  end
  
  def self.with_ratings(ratings_list=nil)
    if ratings_list
      Movie.where('rating in (?)',ratings_list.keys)
    else
      Movie.all
    end
  end
end
