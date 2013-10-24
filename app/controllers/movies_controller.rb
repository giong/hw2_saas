class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    @filter_ratings = params[:ratings]
    @sort = params[:sort]
    @movies = Movie.all
    
    #retrieve and set sort from session
    if @sort.nil?
      @sort = session[:sort]
    else
      session[:sort] = @sort
    end
    
    #retrieve and set ratings from session
    if @filter_ratings.nil?
      @filter_ratings = session[:ratings]
    else
      session[:ratings] = @filter_ratings
    end
    
    #redirect to if lack of sort parameter
    if params[:sort].nil? && session[:sort]
      redirect_to movies_path(:sort => @sort, :ratings => @filter_ratings) and return
    end

    #redirect to if lack of ratings parameter
    if params[:ratings].nil? && session[:ratings]
      redirect_to movies_path(:sort => @sort, :ratings => @filter_ratings) and return
    end
    
    #filter movie by rating when submit or from session 
    if @filter_ratings
      @movies = Movie.find_all_by_rating(@filter_ratings.keys)
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
