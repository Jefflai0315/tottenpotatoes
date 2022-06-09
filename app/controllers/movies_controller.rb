class MoviesController < ApplicationController
  @ratings_to_show_hash = []

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    

    #for first time visit
    if (params[:ratings] == nil && session[:ratings] == false)
      session[:ratings] = Hash[]
      redirect_to movies_path(ratings: Hash[])
    end

    if (params[:ratings]!= session[:ratings])
      session[:ratings] = params[:ratings]
    end

    @all_ratings = ['G','PG','PG-13','R']
    ratings = params[:ratings] != nil ? params[:ratings].keys : []
    @ratings_to_show_hash = ratings
    @movies = ratings == [] ? Movie.all : Movie.where(rating: ratings)
    

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

  # def 
  #   rating = params[:rating]
  #   if @ratings_to_show_hash.include?(rating)
  #     #remove rating
  #   else
  #     @ratings_to_show_hash.append(rating)
  #   end
end
