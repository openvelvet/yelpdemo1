class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :set_restaurant
  before_action :authenticate_user!
  before_action :check_user, only: [:edit, :update, :destroy]

  respond_to :html

  def index
    @reviews = Review.all
    respond_with(@reviews)
  end

  def show
    respond_with(@review)
  end

  def new
    @review = Review.new
    respond_with(@review)
  end

  def edit
  end

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @review.restaurant_id = @restaurant.id
    @review.save
    
    flash[:notice] = "Review was successfully created." if @review.save 
    respond_with(@review, :location => @restaurant) 
  end

  def update
    @review.update(review_params)
    respond_with(@review, :location => @restaurant)
  end

  def destroy
    @review.destroy
    respond_with(@review, :location => @restaurant)
  end

  private
    def set_review
      @review = Review.find(params[:id])
    end

    def set_restaurant
      @restaurant = Restaurant.find(params[:restaurant_id])
    end

    def check_user
      unless (@review.user == current_user) || (current_user.admin?)
        redirect_to root_url, alert: "Sorry, this review belongs to another user"
      end
    end

    def review_params
      params.require(:review).permit(:rating, :comment)
    end
end
