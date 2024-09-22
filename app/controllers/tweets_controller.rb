class TweetsController < ApplicationController
  before_action :set_tweet, only: %i[ show edit update destroy like retweet]
  before_action :authenticate_user!

  # GET /tweets or /tweets.json
  def index
    @tweets = Tweet.all.order(created_at: :desc)
    @tweet = Tweet.new
  end

  # GET /tweets/1 or /tweets/1.json
  def show
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets or /tweets.json
  def create
    @tweet = current_user.tweets.build(tweet_params)

    if @tweet.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append("tweets", partial: "tweets/tweet", locals: { tweet: @tweet })
        end
        format.html { redirect_to tweets_path, notice: "Tweet was successfully created." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_tweet", partial: "tweets/form", locals: { tweet: @tweet }) }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tweets/1 or /tweets/1.json
  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to @tweet, notice: "Tweet was successfully updated." }
        format.json { render :show, status: :ok, location: @tweet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  def like
    @tweet.increment! :likes_count

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to tweets_path, notice: "Tweet liked!" }
    end
  end

  def retweet
    @retweet = current_user.retweets.build(tweet: @tweet)

    if @retweet.save
      @tweet.increment! :retweets_count
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to tweets_path, notice: "Retweeted!" }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_tweet", inline: "Already retweeted") }
        # format.turbo_stream { render turbo_stream: turbo_stream.replace("new_tweet", partial: "tweets/form", locals: { tweet: @tweet }) }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/1 or /tweets/1.json
  def destroy
    @tweet.destroy!

    respond_to do |format|
      format.html { redirect_to tweets_path, status: :see_other, notice: "Tweet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tweet_params
      params.require(:tweet).permit(:body, :likes_count, :retweets_count)
    end
end
