class MoviesController < ApplicationController

  def show
    @filter_params = {}
    unless session[:filter_ratings].nil?
      session[:filter_ratings].each do |f|
       @filter_params[f] = 1
      end
    end
    
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    @filter_ratings = params[:ratings].keys unless params[:ratings].nil?
    @sort = params[:sort]
    @movies = Movie.all
    
    #set or retrieve session for sort
    #redirect to if lack of sort parameter
    if params[:sort].nil? && session[:sort]
      @sort = session[:sort]
      redirect_to movies_path(:sort => session[:sort], :ratings => params[:ratings])
    else
      session[:sort] = @sort
    end
    
    #set or retrieve session for filter
    #redirect to if lack of ratings parameter
    if params[:ratings].nil? && session[:filter_ratings]
      @filter_ratings = session[:filter_ratings].keys
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:filter_ratings])
    else
      session[:filter_ratings] = params[:ratings]
    end
    
    #filter movie by rating when submit or from session 
    if params[:commit] == "Refresh" || session[:filter_ratings]
      @movies = Movie.find_all_by_rating(@filter_ratings)
    end
    #sort movie by title and release date
    if @sort == "title"
      @movies = @movies.sort_by{ |m| m.title }
    elsif @sort == "date" 
      @movies = @movies.sort_by{ |m| m.release_date }
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
