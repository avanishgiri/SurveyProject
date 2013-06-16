helpers do
  def gravatar_url(email, size = 200)
    hash = Digest::MD5.hexdigest(email.downcase)
    "https://secure.gravatar.com/avatar/#{hash}?s=#{size}" if hash
  end
end