module StreamHelper
  def tweet_align(index)
    index % 2 == 0 ? "left" : "right"
  end
end
