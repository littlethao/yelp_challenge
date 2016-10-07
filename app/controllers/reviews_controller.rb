class ReviewsController < ApplicationController

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.build_with_user(review_params, current_user)
    if @review.save
      redirect_to '/restaurants'
    else
      if @review.errors[:user]
        # Note: if you have correctly disabled the review button where appropriate,
        # this should never happen...
        redirect_to '/restaurants', alert: 'You have already reviewed this restaurant'
      else
        # Why would we render new again?  What else could cause an error?
        render :new
      end
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.find(params[:id])
    if @review.user_id == current_user.id
      @review.update(review_params)
    else
      flash[:alert] = 'Not allowed'
    end
    redirect_to '/restaurants'
  end

  def destroy
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.find(params[:id])
    if @review.user_id == current_user.id
      @review.destroy
      flash[:notice] = 'Review deleted successfully'
    else
      flash[:alert] = 'Not allowed'
    end
    redirect_to '/restaurants'
  end

  private
  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end
end
