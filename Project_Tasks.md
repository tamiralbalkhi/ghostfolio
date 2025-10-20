# Ghostfolio to Ruby on Rails Migration - Project Tasks

## Overview
This document outlines the detailed tasks for migrating the Ghostfolio TypeScript/NestJS codebase to Ruby on Rails API that integrates with the existing maybe-finance application.

## Project Phases

### Phase 1: Foundation Setup (Weeks 1-4)

#### 1.1 Rails Application Setup
- [ ] Create new Rails API application in maybe-finance-api folder
  ```bash
  rails new maybe-finance-api --api --database=postgresql --skip-test
  ```
- [ ] Configure Gemfile with required gems (see detailed Gemfile below)
- [ ] Run `bundle install` to install all dependencies
- [ ] Configure application settings in `config/application.rb`
- [ ] Set up environment variables with `.env` files
- [ ] Configure Redis connection for caching and background jobs
- [ ] Set up Rails credentials for sensitive data
- [ ] Configure time zones and locale settings
- [ ] Set up logging configuration for structured logs
- [ ] Configure ActiveRecord settings for API optimization

**Complete Gemfile Configuration:**
```ruby
source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Ruby version - adjust based on your system
ruby "3.2.0"  # Or use ruby "2.6.10" if you prefer to use system Ruby

# Core Rails gems
gem "rails", "~> 7.0.4"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"

# Authentication & Authorization
gem "devise", "~> 4.9"
gem "devise-jwt", "~> 0.10.0"  # JWT token authentication
gem "pundit", "~> 2.3"         # Authorization policies

# API & Serialization
gem "rack-cors"                 # CORS handling
gem "active_model_serializers", "~> 0.10.0"
gem "jbuilder", "~> 2.7"       # JSON templates
gem "kaminari", "~> 1.2"       # Pagination

# Background Jobs & Caching
gem "redis", "~> 4.0"
gem "sidekiq", "~> 7.0"
gem "sidekiq-web", "~> 0.0.9"

# External API Integration
gem "httparty", "~> 0.21"
gem "faraday", "~> 2.7"        # HTTP client
gem "faraday-retry", "~> 2.0"  # Retry logic

# Financial & Currency
gem "money-rails", "~> 1.15"
gem "currencies", "~> 0.4.2"   # Currency data

# Database & Performance
gem "pg_search", "~> 2.3"      # Full-text search
gem "bullet", "~> 7.0"         # N+1 query detection (dev/test)

# Configuration & Environment
gem "dotenv-rails", "~> 2.8"
gem "config", "~> 4.2"         # Application configuration

# Monitoring & Logging
gem "lograge", "~> 0.12"       # Structured logging
gem "amazing_print", "~> 1.4"  # Pretty printing

# Security
gem "strong_password", "~> 0.0.9"
gem "rack-attack", "~> 6.6"    # Rate limiting
gem "secure_headers", "~> 6.5" # Security headers

# Documentation
gem "rswag", "~> 2.8"          # Swagger/OpenAPI docs

# Validation & Utilities
gem "validates_email_format_of", "~> 1.7"
gem "chronic", "~> 0.10.2"     # Natural language date parsing

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", "~> 1.16", require: false

group :development, :test do
  # Testing framework
  gem "rspec-rails", "~> 6.0"
  gem "factory_bot_rails", "~> 6.2"
  gem "faker", "~> 3.1"
  
  # Code quality
  gem "rubocop", "~> 1.48"
  gem "rubocop-rails", "~> 2.17"
  gem "rubocop-rspec", "~> 2.18"
  gem "rubocop-performance", "~> 1.16"
  
  # Debugging
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "pry-rails", "~> 0.3.9"
  gem "pry-byebug", "~> 3.10"
end

group :development do
  # Development tools
  gem "listen", "~> 3.3"
  gem "spring", "~> 4.1"
  gem "spring-watcher-listen", "~> 2.1"
  
  # Performance profiling
  gem "rack-mini-profiler", "~> 3.0"
  
  # Database tools
  gem "annotate", "~> 3.2"       # Model annotations
end

group :test do
  # Testing utilities
  gem "shoulda-matchers", "~> 5.3"
  gem "webmock", "~> 3.18"       # HTTP request stubbing
  gem "vcr", "~> 6.1"            # Record HTTP interactions
  gem "database_cleaner-active_record", "~> 2.0"
  gem "timecop", "~> 0.9.6"      # Time travel for tests
  
  # Test coverage
  gem "simplecov", "~> 0.22", require: false
  gem "simplecov-html", "~> 0.12", require: false
end

group :production do
  # Production monitoring
  gem "newrelic_rpm", "~> 8.16"  # Application monitoring
  gem "sentry-ruby", "~> 5.8"    # Error tracking
  gem "sentry-rails", "~> 5.8"
end
```

**Setup Steps:**
1. **Initialize Rails application:**
   ```bash
   cd /path/to/maybe-finance-api
   rails new . --api --database=postgresql --skip-test --force
   ```

2. **Update Gemfile with above configuration**

3. **Fix Ruby version and install dependencies:**
   ```bash
   # First, check your current Ruby version
   ruby --version
   
   # If using system Ruby (2.6.x), you have several options:
   
   # Option 1: Install compatible Bundler for Ruby 2.6.10 (immediate fix)
   gem install bundler -v 2.4.22 --user-install
   
   # Option 2: Use rbenv to install Ruby 3.2.0 (recommended for long-term)
   # Install rbenv if not already installed:
   # brew install rbenv ruby-build
   # rbenv install 3.2.0
   # rbenv global 3.2.0
   # rbenv rehash
   
   # Option 2: Update Gemfile to use your current Ruby version
   # Change ruby "3.2.0" to ruby "2.6.10" in Gemfile
   
   # Option 3: Use --user-install flag (temporary solution)
   gem install bundler --user-install
   bundle install --path vendor/bundle
   ```

4. **Generate RSpec configuration:**
   ```bash
   rails generate rspec:install
   ```

5. **Configure application settings in `config/application.rb`:**
   ```ruby
   config.api_only = true
   config.time_zone = 'UTC'
   config.active_record.default_timezone = :utc
   
   # Generator configuration
   config.generators do |g|
     g.test_framework :rspec
     g.factory_bot dir: 'spec/factories'
     g.serializer false
     g.helper false
     g.assets false
   end
   
   # ActiveRecord optimizations for API
   config.active_record.belongs_to_required_by_default = true
   config.active_record.legacy_connection_handling = false
   
   # Eager load paths for services and lib
   config.eager_load_paths += %W(#{config.root}/app/services)
   config.eager_load_paths += %W(#{config.root}/lib)
   
   # CORS and middleware
   config.middleware.insert_before 0, Rack::Cors
   config.middleware.use Rack::Attack
   
   # Session configuration for API
   config.session_store :disabled
   ```

6. **Set up environment variables:**
   ```bash
   # Create .env files
   touch .env
   touch .env.development
   touch .env.test
   touch .env.production.example
   ```

7. **Configure CORS in `config/initializers/cors.rb`:**
   ```ruby
   Rails.application.config.middleware.insert_before 0, Rack::Cors do
     allow do
       origins ENV.fetch('ALLOWED_ORIGINS', 'http://localhost:4200').split(',')
       resource '*',
         headers: :any,
         methods: [:get, :post, :put, :patch, :delete, :options, :head],
         credentials: true
     end
   end
   ```

8. **Configure Redis connection in `config/initializers/redis.rb`:**
   ```ruby
   Redis.current = Redis.new(
     url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'),
     timeout: 1,
     reconnect_attempts: 3
   )
   ```

9. **Set up Rails credentials:**
   ```bash
   # Generate master key and credentials file
   rails credentials:edit
   
   # Add to credentials file:
   # devise_jwt_secret_key: <generate_random_key>
   # yahoo_finance_api_key: <your_api_key>
   # coingecko_api_key: <your_api_key>
   ```

10. **Configure Sidekiq in `config/initializers/sidekiq.rb`:**
    ```ruby
    Sidekiq.configure_server do |config|
      config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
    end
    ```

11. **Configure structured logging in `config/initializers/lograge.rb`:**
    ```ruby
    Rails.application.configure do
      config.lograge.enabled = true
      config.lograge.formatter = Lograge::Formatters::Json.new
      
      config.lograge.custom_payload do |controller|
        {
          user_id: controller.current_user&.id,
          request_id: controller.request.uuid,
          ip: controller.request.remote_ip
        }
      end
    end
    ```

12. **Set up environment variables in `.env.development`:**
    ```bash
    # Database
    DB_HOST=localhost
    DB_PORT=5432
    DB_USERNAME=postgres
    DB_PASSWORD=

    # Redis
    REDIS_URL=redis://localhost:6379/0

    # API Origins
    ALLOWED_ORIGINS=http://localhost:4200,http://localhost:3000

    # External APIs
    YAHOO_FINANCE_BASE_URL=https://query1.finance.yahoo.com
    COINGECKO_BASE_URL=https://api.coingecko.com/api/v3

    # Application Settings
    RAILS_MAX_THREADS=5
    RAILS_MIN_THREADS=5
    ```

#### 1.2 Database Schema Migration

- [ ] Configure `config/database.yml` for PostgreSQL
- [ ] Create database and run initial setup
- [ ] Create User model migration (migrate from Prisma User schema)
- [ ] Create Account model migration
- [ ] Create Symbol model migration (migrate from SymbolProfile)
- [ ] Create Order model migration (migrate from Order schema)
- [ ] Create Subscription model migration (for premium features)
- [ ] Create Settings model migration
- [ ] Create AuthDevice model migration
- [ ] Set up database indexes for performance
- [ ] Configure database.yml for development/test/production

**Database Configuration Steps:**

1. **Configure `config/database.yml`:**
   ```yaml
   default: &default
     adapter: postgresql
     encoding: unicode
     pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
     timeout: 5000
     host: <%= ENV.fetch("DB_HOST", "localhost") %>
     port: <%= ENV.fetch("DB_PORT", "5432") %>
     username: <%= ENV.fetch("DB_USERNAME", "postgres") %>
     password: <%= ENV.fetch("DB_PASSWORD", "") %>

   development:
     <<: *default
     database: maybe_finance_api_development

   test:
     <<: *default
     database: maybe_finance_api_test

   production:
     <<: *default
     database: <%= ENV.fetch("DB_NAME", "maybe_finance_api_production") %>
     username: <%= ENV.fetch("DB_USERNAME") %>
     password: <%= ENV.fetch("DB_PASSWORD") %>
   ```

2. **Create databases:**
   ```bash
   rails db:create
   rails db:create RAILS_ENV=test
   ```

3. **Generate core migrations:**
   ```bash
   # User migration
   rails generate migration CreateUsers id:string email:string encrypted_password:string first_name:string last_name:string role:string is_demo_user:boolean settings:jsonb

   # Account migration  
   rails generate migration CreateAccounts id:string user:references name:string currency:string is_default:boolean

   # Symbol migration
   rails generate migration CreateSymbols id:string asset_class:string asset_sub_class:string comment:text currency:string data_source:string isin:string name:string scraped_data:jsonb sectors:jsonb symbol:string

   # Order migration
   rails generate migration CreateOrders id:string account:references user:references symbol:references type:string quantity:decimal unit_price:decimal currency:string fee:decimal comment:text date:date

   # Subscription migration
   rails generate migration CreateSubscriptions id:string user:references status:string plan:string starts_at:datetime ends_at:datetime

   # Settings migration
   rails generate migration CreateSettings id:string user:references key:string value:jsonb

   # AuthDevice migration
   rails generate migration CreateAuthDevices id:string user:references device_id:string device_type:string last_used_at:datetime
   ```

4. **Customize migration files with proper constraints:**
   ```ruby
   # Example: db/migrate/xxx_create_users.rb
   class CreateUsers < ActiveRecord::Migration[7.0]
     def change
       create_table :users, id: false do |t|
         t.string :id, primary_key: true, null: false
         t.string :email, null: false
         t.string :encrypted_password, null: false
         t.string :first_name
         t.string :last_name
         t.string :role, default: 'user'
         t.boolean :is_demo_user, default: false
         t.jsonb :settings, default: {}
         t.timestamps
       end

       add_index :users, :email, unique: true
       add_index :users, :role
       add_index :users, :is_demo_user
     end
   end
   ```

5. **Run migrations:**
   ```bash
   rails db:migrate
   rails db:migrate RAILS_ENV=test
   ```


#### 1.3 Authentication & Authorization Setup

- [ ] Configure Devise for user authentication
- [ ] Implement JWT token authentication with devise-jwt
- [ ] Set up Pundit policies for authorization
- [ ] Create user roles (user, admin)
- [ ] Implement demo user functionality
- [ ] Set up CORS configuration for API access

**Authentication Configuration Steps:**

1. **Install and configure Devise:**
   ```bash
   rails generate devise:install
   rails generate devise User
   ```

2. **Configure JWT authentication in `config/initializers/devise.rb`:**
   ```ruby
   Devise.setup do |config|
     config.jwt do |jwt|
       jwt.secret = Rails.application.credentials.devise_jwt_secret_key
       jwt.dispatch_requests = [
         ['POST', %r{^/api/v1/users/sign_in$}],
         ['POST', %r{^/api/v1/users/sign_up$}]
       ]
       jwt.revocation_requests = [
         ['DELETE', %r{^/api/v1/users/sign_out$}]
       ]
       jwt.expiration_time = 1.day.to_i
     end
   end
   ```

3. **Update User model for JWT:**
   ```ruby
   class User < ApplicationRecord
     include Devise::JWT::RevocationStrategies::JTIMatcher
     
     devise :database_authenticatable, :registerable,
            :jwt_authenticatable, jwt_revocation_strategy: self
     
     enum role: { user: 'user', admin: 'admin' }
     
     validates :email, presence: true, uniqueness: true
     validates :role, presence: true
   end
   ```

4. **Generate Pundit configuration:**
   ```bash
   rails generate pundit:install
   ```

5. **Create base application policy:**
   ```ruby
   # app/policies/application_policy.rb
   class ApplicationPolicy
     def initialize(user, record)
       @user = user
       @record = record
     end

     def index?
       user.present?
     end

     def show?
       user.present?
     end

     def create?
       user.present?
     end

     def update?
       user.present? && (user.admin? || owner?)
     end

     def destroy?
       user.present? && (user.admin? || owner?)
     end

     private

     attr_reader :user, :record

     def owner?
       record.respond_to?(:user_id) && record.user_id == user.id
     end
   end
   ```

#### 1.4 Basic Project Structure
- [ ] Set up controllers directory structure (Api::V1 namespace)
- [ ] Create base application controller with error handling
- [ ] Set up services directory
- [ ] Configure serializers directory
- [ ] Set up background jobs directory
- [ ] Create lib directory for utilities

### Phase 2: Core Models & Business Logic (Weeks 5-8)

#### 2.1 User Management
- [ ] Implement User model with validations
- [ ] Add user settings as JSONB field
- [ ] Implement user preferences (currency, theme, etc.)
- [ ] Add user subscription status tracking
- [ ] Create user factory for testing

#### 2.2 Account Management
- [ ] Implement Account model with validations
- [ ] Add multi-currency support
- [ ] Implement default account logic
- [ ] Add account balance calculations
- [ ] Create account factory and specs

#### 2.3 Symbol/Asset Management
- [ ] Implement Symbol model (stocks, ETFs, crypto, etc.)
- [ ] Add asset class and sub-class categorization
- [ ] Implement ISIN and symbol validation
- [ ] Add sectors and market data fields
- [ ] Create symbol factory and specs

#### 2.4 Order/Activity Management
- [ ] Implement Order model with all activity types:
  - [ ] BUY orders
  - [ ] SELL orders
  - [ ] DIVIDEND receipts
  - [ ] FEE transactions
  - [ ] INTEREST transactions
  - [ ] LIABILITY transactions
- [ ] Add order validations and business rules
- [ ] Implement quantity and pricing calculations
- [ ] Add currency conversion support
- [ ] Create order factory and comprehensive specs

### Phase 3: API Controllers & Endpoints (Weeks 9-12)

#### 3.1 Portfolio API
- [ ] Create Portfolio controller
- [ ] Implement GET /api/v1/portfolio endpoint
- [ ] Add portfolio performance calculations
- [ ] Implement holdings overview endpoint
- [ ] Add portfolio allocation breakdown
- [ ] Create portfolio serializers

#### 3.2 Orders API
- [ ] Create Orders controller
- [ ] Implement CRUD operations for orders:
  - [ ] GET /api/v1/orders (list with pagination)
  - [ ] POST /api/v1/orders (create)
  - [ ] PUT /api/v1/orders/:id (update)
  - [ ] DELETE /api/v1/orders/:id (delete)
- [ ] Add bulk import functionality
- [ ] Implement export functionality
- [ ] Add filtering and sorting capabilities

#### 3.3 Accounts API
- [ ] Create Accounts controller
- [ ] Implement account CRUD operations
- [ ] Add account balance calculations
- [ ] Implement default account management

#### 3.4 Symbols API
- [ ] Create Symbols controller
- [ ] Implement symbol search functionality
- [ ] Add symbol details endpoint
- [ ] Create symbol lookup by ISIN/ticker

### Phase 4: Data Providers & Market Data (Weeks 13-16)

#### 4.1 Data Provider Services
- [ ] Create DataProviderService interface
- [ ] Implement YahooFinanceService:
  - [ ] Real-time quotes
  - [ ] Historical data
  - [ ] Currency exchange rates
- [ ] Implement CoinGeckoService for crypto data
- [ ] Add manual data entry support
- [ ] Create data provider factory pattern

#### 4.2 Market Data Management
- [ ] Create MarketData model for storing quotes
- [ ] Implement real-time data updates
- [ ] Add historical price storage
- [ ] Create exchange rate management
- [ ] Implement data freshness validation

#### 4.3 Background Job Processing
- [ ] Set up Sidekiq for background jobs
- [ ] Create DataGatheringJob for market data updates
- [ ] Implement PortfolioCalculationJob
- [ ] Add email notification jobs
- [ ] Create job monitoring and error handling

### Phase 5: Business Logic Services (Weeks 17-20)

#### 5.1 Portfolio Calculation Service
- [ ] Implement PortfolioService for overview calculations
- [ ] Create PerformanceCalculatorService:
  - [ ] Today performance
  - [ ] Week-to-date (WTD)
  - [ ] Month-to-date (MTD)
  - [ ] Year-to-date (YTD)
  - [ ] 1 Year performance
  - [ ] 5 Year performance
  - [ ] Max performance
- [ ] Implement ROAI (Return on Average Investment) calculations
- [ ] Add time-weighted return calculations

#### 5.2 Analytics Services
- [ ] Create AllocationService for asset allocation
- [ ] Implement CategoryAnalysisService
- [ ] Create RiskAnalysisService (X-ray functionality)
- [ ] Add InvestmentStreakService
- [ ] Implement BenchmarkComparisonService

#### 5.3 Import/Export Services
- [ ] Create OrderImportService for CSV/JSON imports
- [ ] Implement data validation and error handling
- [ ] Add export functionality for various formats
- [ ] Create template generation for imports

### Phase 6: Advanced Features (Weeks 21-24)

#### 6.1 Multi-Currency Support
- [ ] Implement currency conversion service
- [ ] Add real-time exchange rate updates
- [ ] Create base currency management
- [ ] Implement multi-currency portfolio calculations

#### 6.2 Premium Features
- [ ] Implement subscription management
- [ ] Add premium feature gates
- [ ] Create advanced analytics for premium users
- [ ] Implement usage tracking

#### 6.3 Internationalization
- [ ] Set up Rails I18n framework
- [ ] Migrate translation files from Angular format
- [ ] Implement locale detection and management
- [ ] Add currency and number formatting

### Phase 7: Testing & Quality Assurance (Weeks 25-28)

#### 7.1 Unit Testing
- [ ] Write comprehensive model specs
- [ ] Create controller request specs
- [ ] Add service class unit tests
- [ ] Implement job testing
- [ ] Achieve 90%+ test coverage

#### 7.2 Integration Testing
- [ ] Create API integration tests
- [ ] Test data provider integrations
- [ ] Add background job integration tests
- [ ] Test currency conversion workflows

#### 7.3 Performance Testing
- [ ] Load test critical API endpoints
- [ ] Optimize database queries
- [ ] Implement caching strategies
- [ ] Profile background job performance

### Phase 8: DevOps & Deployment (Weeks 29-32)

#### 8.1 Docker Configuration
- [ ] Create Dockerfile for Rails application
- [ ] Update docker-compose.yml
- [ ] Configure production environment variables
- [ ] Set up health check endpoints

#### 8.2 Database Migration Scripts
- [ ] Create data migration scripts from existing Ghostfolio
- [ ] Implement data validation scripts
- [ ] Create rollback procedures
- [ ] Test migration on staging environment

#### 8.3 API Documentation
- [ ] Generate Swagger/OpenAPI documentation
- [ ] Create API usage examples
- [ ] Document authentication flows
- [ ] Add rate limiting documentation

### Phase 9: Integration with maybe-finance (Weeks 33-36)

#### 9.1 Shared Services
- [ ] Create shared authentication service
- [ ] Implement cross-application user management
- [ ] Add shared Redis caching
- [ ] Create shared background job processing

#### 9.2 Data Synchronization
- [ ] Implement user data sync between applications
- [ ] Create portfolio data sharing mechanisms
- [ ] Add financial goal integration
- [ ] Implement unified reporting

#### 9.3 Frontend Migration Strategy
- [ ] Plan Angular frontend migration approach
- [ ] Create Rails view layer (optional)
- [ ] Implement Hotwire/Turbo for SPA-like experience
- [ ] Add mobile-responsive design

## Technical Debt & Optimization Tasks

### Performance Optimization
- [ ] Implement database query optimization
- [ ] Add Redis caching for frequently accessed data
- [ ] Optimize API response times
- [ ] Implement pagination for large datasets

### Security & Compliance
- [ ] Implement proper API rate limiting
- [ ] Add input validation and sanitization
- [ ] Create audit logging for sensitive operations
- [ ] Implement proper error handling without data leakage

### Monitoring & Observability
- [ ] Set up application monitoring (New Relic/DataDog)
- [ ] Implement structured logging
- [ ] Add performance metrics collection
- [ ] Create alerting for critical failures

## Success Metrics

### Functional Requirements
- [ ] All existing Ghostfolio features replicated
- [ ] API response times < 200ms for critical endpoints
- [ ] 99.9% uptime during business hours
- [ ] Support for 10,000+ concurrent users

### Quality Metrics
- [ ] 90%+ test coverage
- [ ] Zero critical security vulnerabilities
- [ ] API documentation completeness score > 95%
- [ ] Code quality score > 8.0 (SonarQube)

## Risk Mitigation

### Technical Risks
- [ ] Create parallel testing environment
- [ ] Implement feature flags for gradual rollout
- [ ] Maintain backward compatibility during transition
- [ ] Create automated testing pipeline

### Business Risks
- [ ] Plan for zero-downtime migration
- [ ] Create user communication strategy
- [ ] Implement rollback procedures
- [ ] Maintain data backup and recovery plans

## Timeline Summary

| Phase | Duration | Key Deliverables |
|-------|----------|------------------|
| 1 | Weeks 1-4 | Rails setup, authentication, basic models |
| 2 | Weeks 5-8 | Core business logic, models, validations |
| 3 | Weeks 9-12 | API controllers, CRUD operations |
| 4 | Weeks 13-16 | Data providers, market data integration |
| 5 | Weeks 17-20 | Portfolio calculations, analytics |
| 6 | Weeks 21-24 | Advanced features, premium functionality |
| 7 | Weeks 25-28 | Testing, quality assurance |
| 8 | Weeks 29-32 | DevOps, deployment, documentation |
| 9 | Weeks 33-36 | Integration with maybe-finance |

**Total Project Duration: 36 weeks (9 months)**

## Quick Start Guide

### Phase 1 Implementation Priority

1. **Week 1 - Foundation Setup:**
   - Create Rails API app with detailed Gemfile
   - Configure PostgreSQL database
   - Set up basic authentication with Devise + JWT

2. **Week 2 - Core Models:**
   - Implement User, Account, Symbol, Order models
   - Create database migrations with proper indexes
   - Set up model validations and relationships

3. **Week 3 - Basic API:**
   - Create API controllers for core resources
   - Implement basic CRUD operations
   - Set up serializers for JSON responses

4. **Week 4 - Testing Foundation:**
   - Configure RSpec testing framework
   - Create factories and basic test coverage
   - Set up CI/CD pipeline basics

### Gemfile Review Summary

The comprehensive Gemfile includes:

**🔧 Core Functionality:**
- `devise` + `devise-jwt` for secure authentication
- `pundit` for authorization policies
- `sidekiq` + `redis` for background job processing
- `money-rails` for precise financial calculations

**🚀 Performance & Scalability:**
- `kaminari` for pagination
- `bullet` for N+1 query detection
- `rack-mini-profiler` for performance monitoring
- `pg_search` for full-text search capabilities

**🔒 Security & Monitoring:**
- `rack-attack` for rate limiting
- `secure_headers` for security headers
- `sentry-ruby` for error tracking
- `newrelic_rpm` for application monitoring

**🧪 Testing & Quality:**
- `rspec-rails` with comprehensive testing suite
- `rubocop` family for code quality
- `simplecov` for test coverage analysis
- `factory_bot_rails` + `faker` for test data

**📡 External Integration:**
- `httparty` + `faraday` for API communications
- `webmock` + `vcr` for testing external APIs
- `chronic` for date parsing

This setup provides a production-ready foundation for the Ghostfolio migration while maintaining high code quality and performance standards.

## Notes

- This migration maintains all existing Ghostfolio functionality while moving to Ruby on Rails
- The API design prioritizes compatibility with the existing Angular frontend
- Integration with maybe-finance is planned for the final phase
- Each phase includes comprehensive testing and documentation
- Performance optimization is ongoing throughout all phases
