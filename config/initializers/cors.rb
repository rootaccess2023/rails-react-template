Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Allow requests from your React server
    origins 'http://localhost:3000', 'http://127.0.0.1:3000'
    
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true,
      expose: ['Authorization']
  end
end