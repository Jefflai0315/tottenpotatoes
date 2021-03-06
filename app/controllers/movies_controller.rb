class MoviesController < ApplicationController
  @ratings_to_show_hash = []

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  #init
    if session[:ratings] == false
      session[:ratings] = ' '
    end
    if session[:sort_by] == false
      session[:sort_by] = ' '
    end


    #did not pressed refresh and pressed sort
    if params[:sort_by] != nil && params[:ratings] != nil
      session[:sort_by] = params[:sort_by]

    #pressed refresh and did not pressed sort
    elsif params[:sort_by] == nil && params[:ratings] != nil 
      session[:ratings] = params[:ratings] 
    end

    #if user unchecked all ratings
    if params[:sort_by] == nil && params[:ratings] == nil && params[:home] == '1'
      session[:ratings] = params[:ratings] 
    end


    @all_ratings = ['G','PG','PG-13','R']
    ratings = session[:ratings] != nil ? session[:ratings].keys : @all_ratings
    
    @ratings_to_show_hash = ratings
    @movies = ratings == [] ? Movie.all : Movie.where(rating: ratings)

    if session[:sort_by] == "title" 
      @movies = @movies.order("title")
    elsif session[:sort_by] == "release_date" 
      @movies = @movies.order("release_date")
    end


    @session_s = session[:sort_by]
    @session_r = session[:ratings]
    @title_header = (session[:sort_by]=='title') ? 'hilite bg-warning' : ''
    @release_date_header = (session[:sort_by]=='release_date') ? 'hilite bg-warning' : ''
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
