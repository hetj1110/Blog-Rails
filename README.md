# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

user.rb
  # validates :state, inclusion: { in: -> (record) { record.states.keys }, allow_blank: true }
  # validates :state, presence: { if: -> (record) { record.states.present? } }
  # validates :city, inclusion: { in: -> (record) { record.cities.keys }, allow_blank: true }
  # validates :city, presence: { if: -> (record) { record.states.present? } }


  # def states
  #   CS.states(country).with_indifferent_access
  # end

  # def cities
  #   CS.cities(state,country) || []
  # end


  # ATBB9J3JXY3PXwsE86R8ERgBBYm2C5900663