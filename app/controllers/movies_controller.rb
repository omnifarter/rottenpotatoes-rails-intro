class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # we only set to load from session if there was no ratings params, and it wasn't from a refresh of ratings
    if params['ratings'] == nil and session[:ratings] and params['commit'] != 'Refresh'
      params['ratings'] = session[:ratings]
    end
    if params['sort'] == nil and session[:sort]
      params['sort'] = session[:sort]
    end
    @all_ratings = Movie.all_ratings
    @ratings_to_show_hash = params['ratings'] || {'G':1,'PG':1,'PG-13':1,'R':1}
    @sorting = params['sort']
    @movies = Movie.with_ratings(params['ratings'])
    if params['sort']
      @movies = @movies.order(params['sort'])
    end
   session[:sort] = params['sort']
   session[:ratings] = params['ratings']
  end
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
