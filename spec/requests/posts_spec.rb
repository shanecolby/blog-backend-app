require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    it "should show you all the posts" do
      user = User.create!(
        name: "Stan",
        email: "stansdonuts@yahoo.com",
        password_digest: "password"
      )

      Post.create!(
        user_id: user.id,
        title: "Happy Post",
        body: "I am very happy",
        image: "jsadhasjdha"
      )
      Post.create!(
        user_id: user.id,
        title: "Sad post",
        body: "I am very sad :(",
        image: "ooorooroororororo"
      )
      Post.create!(
        user_id: user.id,
        title: "Content post",
        body: "I am kinda in the middle",
        image: "dfdfknndndndnndndnn"
      )




      get '/api/posts'
      posts = JSON.parse(response.body)
      p response.body
      expect(response).to have_http_status(200)
      expect(posts.length).to eq(3)
    end
  end

  describe "POST /posts" do
    it 'should create a post' do
      user = User.create!(
        name: "Magnus",
        email: "mag-a-tron@yahoo.com",
        password_digest: "password"
      )
      jwt = JWT.encode(
        {
          user: user.id, # the data to encode
          exp: 24.hours.from_now.to_i # the expiration time
        },
        "random", # the secret key
        'HS256' # the encryption algorithm
      )
      post "/api/posts", params: {
        user_id: user.id,
        title: "TEST POST",
        body: "this is the body of the test post",
        image: "test.image"
      }, headers: {
        "Authorization" => "Bearer #{jwt}"
      }
    
      post = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(post['title']).to eq("TEST POST")

    end
  end

end
